package tv.superawesome.libvast.savastmodels {
	public class SAImpression {
		
		public var isSent: Boolean = false;
		public var URL: String = null;
		
		public function SAImpression(){
		}
		
		public function print(): void {
			trace("Impression ==> " + URL);
		}
	}
}