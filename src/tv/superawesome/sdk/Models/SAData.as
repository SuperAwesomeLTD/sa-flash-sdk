package tv.superawesome.sdk.Models {
	
	// SAData class
	public class SAData {
		
		// a path to an image
		public var imagePath:String;
		
		// the vast ads object
		public var vastAds:Array = new Array();
		
		public function SAData() {
			// do nothing
		}
		
		public function print(): void {
			trace("\t\tData:");
			trace("\t\t\timagepath: " + imagePath);
			trace("\t\t\tvastAds: " + vastAds.length);
		}
	}
}