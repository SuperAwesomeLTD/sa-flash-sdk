package tv.superawesome.sdk.AdParser.Parser {
	public class SAVASTData {
		public var clickThroughURL: String;
		public var playableMediaURL: String;
		public var clickTracking: Array;
		public var impressions: Array;
		public var completedURL: Array;
		public var mediaFiles: Array;
		
		public function SAVASTData(){
			clickThroughURL = null;
			clickTracking = new Array();
			impressions = new Array();
			completedURL = new Array();
			mediaFiles = new Array();
			playableMediaURL = null;
		}
		
		public function print(): void {
			trace("clickThroughURL: " + clickThroughURL);
			trace("playableMediaURL: " + playableMediaURL);
			for (var i: int = 0; i < clickTracking.length; i++){
				trace("clickTracking["+i+"]: " + clickTracking[i]);
			}
			for (var j: int = 0; j < mediaFiles.length; j++){
				trace("impressions["+j+"]: " + impressions[j]);
			}
			for (var k: int = 0; k < mediaFiles.length; k++){
				trace("mediaFiles["+k+"]: " + mediaFiles[k]);
			}
			for (var t: int = 0; t < completedURL.length; t++){
				trace("completedURL["+t+"]: " + completedURL[t]);
			}
		}
	}
}