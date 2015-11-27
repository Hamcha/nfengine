package main

import (
	"bytes"
	"encoding/json"
	"encoding/xml"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

type XMLTiledMap struct {
	XMLName     xml.Name     `xml:"map"`
	RenderOrder string       `xml:"renderorder,attr"`
	Width       int          `xml:"width,attr"`
	Height      int          `xml:"height,attr"`
	TileWidth   int          `xml:"tilewidth,attr"`
	TileHeight  int          `xml:"tileheight,attr"`
	Tilesets    []XMLTileset `xml:"tileset"`
	Layers      []XMLLayer   `xml:"layer"`
}

type XMLTileset struct {
	Name       string           `xml:"name,attr"`
	TileWidth  int              `xml:"tilewidth,attr"`
	TileHeight int              `xml:"tileheight,attr"`
	TileCount  int              `xml:"tilecount,attr"`
	FirstGID   int              `xml:"firstgid,attr"`
	Image      XMLImage         `xml:"image"`
	Tiles      []XMLTilesetTile `xml:"tile"`
}

type XMLImage struct {
	Source string `xml:"source,attr"`
	Width  int    `xml:"width,attr"`
	Height int    `xml:"height,attr"`
}

type XMLTilesetTile struct {
	ID         int               `xml:"id,attr"`
	Properties []XMLTileProperty `xml:"properties>property"`
}

type XMLTileProperty struct {
	Name  string `xml:"name,attr"`
	Value string `xml:"value,attr"`
}

type XMLLayer struct {
	Name   string       `xml:"name,attr"`
	Width  int          `xml:"width,attr"`
	Height int          `xml:"height,attr"`
	Data   XMLLayerData `xml:"data"`
}

type XMLLayerData struct {
	Tiles []XMLTile `xml:"tile"`
}

type XMLTile struct {
	GID int `xml:"gid,attr"`
}

func main() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [-t] <input.tmx> [output.hx]\n"+
			"nf.Input must be a XML formatted Tiled project.\n"+
			"If the output file argument is missing, output will be sent to stdout\n", os.Args[0])
		flag.PrintDefaults()
	}

	testdec := flag.Bool("t", false, "Test decoding (output JSON instead of HaXe class)")

	flag.Parse()

	var dest *os.File

	switch flag.NArg() {
	case 0:
		// Missing required arguments
		flag.Usage()
		os.Exit(2)
	case 1:
		dest = os.Stdout
	default:
		dest, _ = os.Create(flag.Arg(1))
	}

	srcfile := flag.Arg(0)

	source, _ := os.Open(srcfile)

	var xmlmap XMLTiledMap
	xml.NewDecoder(source).Decode(&xmlmap)

	if *testdec {
		// Test if decoding works
		jsondata, _ := json.Marshal(xmlmap)
		var out bytes.Buffer
		json.Indent(&out, jsondata, "", "    ")
		out.WriteTo(dest)
		return
	}

	name := strings.SplitN(filepath.Base(srcfile), ".", 2)

	fmt.Fprintln(dest, generateClass(name[0], xmlmap))
}

func generateClass(name string, xmlmap XMLTiledMap) string {
	constructor := fmt.Sprintf(
		"\t\tsuper(\"%s\", %d, %d, %d, %d);\n",
		name,
		xmlmap.Width,
		xmlmap.Height,
		xmlmap.TileWidth,
		xmlmap.TileHeight)

	// Prepare collision tileset data
	collisionOffset := 0
	collisionLength := 0
	collisionValues := make(map[int]string)

	// Export tilesets
	tilesets := make([]string, len(xmlmap.Tilesets))
	for i, tileset := range xmlmap.Tilesets {
		// Check for tileset type
		switch tileset.Name {
		case "_COL":
			// Parse collision tileset
			collisionOffset = tileset.FirstGID
			for _, tile := range tileset.Tiles {
				// Get collision type property
				found := false
				colType := ""
				for _, property := range tile.Properties {
					if property.Name == "ColType" {
						found = true
						colType = property.Value
					}
				}
				if found {
					collisionValues[tile.ID] = colType
				}
			}
			collisionLength = len(collisionValues)
		default:
			tilesets[i] = fmt.Sprintf(
				"\t\ttilesets.push(new Tileset(\"%s\", Assets.getBitmapData(\"%s\"), %d, %d, %d));",
				tileset.Name,
				fixPath(tileset.Image.Source),
				tileset.TileWidth,
				tileset.TileHeight,
				tileset.FirstGID)
		}
	}

	// Export layers
	layers := make([]string, len(xmlmap.Layers))
	for i, layer := range xmlmap.Layers {
		// Check for layer type
		switch layer.Name {
		case "_COL":
			// Parse collision layer ids to collision type values
			collisionIds := make([]string, len(layer.Data.Tiles))
			for tid, tile := range layer.Data.Tiles {
				// An empty space is always not a null spot
				if tile.GID == 0 {
					collisionIds[tid] = "TileCollisionType.NULL"
					continue
				}

				// Filter out invalid values (not collider tileset)
				if tile.GID < collisionOffset || tile.GID > collisionOffset+collisionLength {
					collisionIds[tid] = "TileCollisionType.NULL"
					continue
				}

				colType, ok := collisionValues[tile.GID-collisionOffset]
				if ok {
					collisionIds[tid] = "TileCollisionType." + colType
				} else {
					fmt.Fprintf(os.Stderr, "Woops, weird collision ID: %d\n", tile.GID-collisionOffset)
				}
			}

			layers[i] = fmt.Sprintf(
				"\t\tcollision = new CollisionLayer([%s], %d, %d, %d, %d);",
				strings.Join(collisionIds, ",\n\t\t\t"),
				layer.Width,
				layer.Height,
				xmlmap.TileWidth,
				xmlmap.TileHeight)
		default:
			tileIds := make([]string, len(layer.Data.Tiles))
			for tid, tile := range layer.Data.Tiles {
				tileIds[tid] = strconv.Itoa(tile.GID)
			}

			layers[i] = fmt.Sprintf(
				"\t\tlayers.push(new MapLayer([%s], %d, %d, %d, %d));",
				strings.Join(tileIds, ","),
				layer.Width,
				layer.Height,
				xmlmap.TileWidth,
				xmlmap.TileHeight)
		}
	}

	return "package assets.map;\n\n" +
		"import openfl.Assets;\n" +
		"import nf.physics.TileCollider.TileCollisionType;\n" +
		"import nf.graphics.Tilemap;\n\n" +
		"class " + name + " extends Tilemap {\n" +
		"\tpublic function new() {\n" +
		constructor +
		strings.Join(tilesets, "\n") + "\n" +
		strings.Join(layers, "\n") + "\n" +
		"\t}\n}\n"
}

func fixPath(src string) string {
	// Hardcoded because lazy
	return strings.Replace(src, "../../Assets/", "assets/", 1)
}
