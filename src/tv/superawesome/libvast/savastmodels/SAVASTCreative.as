package tv.superawesome.libvast.savastmodels {
	public class SAVASTCreative {
		
		public var type: int = SAVASTCreativeType.Invalid;
		public var id: String = null;
		public var sequence: String = null;
		public var duration: String = null;
		public var clickThrough: String = null;
		public var playableMediaURL: String = null;
		public var MediaFiles: Array;
		public var TrackingEvents: Array;
		public var ClickTracking: Array;
		public var CustomClicks: Array;
		
		public function SAVASTCreative(){
			MediaFiles = new Array();
			TrackingEvents = new Array();
			ClickTracking = new Array();
			CustomClicks = new Array();
		}
		
		public function print(): void {
			var tp: String = null;
			if (type == SAVASTCreativeType.Linear) tp = "Linear";
			else if (type == SAVASTCreativeType.NonLinear) tp = "NonLinear";
			else if (type == SAVASTCreativeType.CompanionAds) tp = "CompanionAds";
			trace("\tid: " + id);
			trace("\tsequence: " + sequence);
			trace("\tduration: " + duration);
			trace("\tclickThrough: " + clickThrough);
			for (var i: int = 0; i < ClickTracking.length; i++) {
				trace("\tClickTracking[" + i + "]: " + ClickTracking[i]);
			}
			for (var j: int = 0; j < CustomClicks.length; j++) {
				trace("\tCustomClicks[" + j + "]: " + CustomClicks[j]);
			}
			for (var t: int = 0; t < TrackingEvents.length; t++) {
				var tracking: SAVASTTracking = TrackingEvents[t];
				trace("\tTrackingEvent[" + tracking.event + "]: " + tracking.URL);
			}
			for (var k: int = 0; k < MediaFiles.length; k++){
				var mediaFile:SAVASTMediaFile = MediaFiles[k];
				trace("\tMedia[" + mediaFile.type + "] (" + mediaFile.width + "x" + mediaFile.height + "): " + mediaFile.URL);
			}
			trace("\tplayableMediaURL: " + playableMediaURL);
		}
		
		public function sumCreative(creative: SAVASTCreative):void {
			this.id = creative.id;
			this.sequence = creative.sequence;
			this.duration = creative.duration;
			
			if (creative.clickThrough) { this.clickThrough = creative.clickThrough; }
			if (creative.playableMediaURL) { this.playableMediaURL = creative.playableMediaURL; }
			
			this.MediaFiles = this.MediaFiles.concat(creative.MediaFiles);
			this.TrackingEvents = this.TrackingEvents.concat(creative.TrackingEvents);
			this.ClickTracking = this.ClickTracking.concat(creative.ClickTracking);
			this.CustomClicks = this.CustomClicks.concat(creative.CustomClicks);
		}
	}
}