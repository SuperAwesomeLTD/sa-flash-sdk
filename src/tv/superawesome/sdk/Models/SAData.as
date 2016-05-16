package tv.superawesome.sdk.Models {
	import tv.superawesome.libvast.savastmodels.SAVASTAd;
	
	// SAData class
	public class SAData {
		
		// a path to an image
		public var imagePath:String;
		
		// the vast ads object
		public var vastAd:SAVASTAd = null;
		
		public function SAData() {
			// do nothing
			// vastAd = new SAVASTAd();
		}
		
		public function print(): void {
			trace("\t\tData:");
			trace("\t\t\timagepath: " + imagePath);
		}
	}
}