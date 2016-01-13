package nf.utils;

interface IRecyclable<T> extends IDisposable {
	public function setBin(bin: RecycleBin<T>): Void;
	public function trash(): Void;
	public function recycle(data: T): Void;
}
