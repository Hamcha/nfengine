package nf.utils;

class RecycleBin<T> {
	public var maxSize: Int;

	private var bin: Array<IRecyclable<T>>;

	public function new(maxSize: Int = 0) {
		this.maxSize = maxSize;
		this.bin = new Array<IRecyclable<T>>();
	}

	public function push(item: IRecyclable<T>): Bool {
		if (maxSize > 0 && bin.length >= maxSize) {
			return false;
		}
		bin.push(item);
		return true;
	}

	public function pop(data: T): Null<IRecyclable<T>> {
		var item: Null<IRecyclable<T>> = bin.pop();
		if (item == null) {
			return null;
		}
		item.recycle(data);
		return item;
	}

	public function dispose() {
		for (item in bin) {
			item.dispose();
		}
	}
}
