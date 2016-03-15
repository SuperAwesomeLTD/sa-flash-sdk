package tv.superawesome.libvast.savastmodels {
	public class SALinearCreative extends SAVASTCreative {
		
		public var id: String = null;
		public var sequence: String = null;
		public var duration: String = null;
		public var clickThrough: String = null;
		public var playableMediaURL: String = null;
		public var MediaFiles: Array;
		public var TrackingEvents: Array;
		public var ClickTracking: Array;
		public var CustomClicks: Array;
		
		public function SALinearCreative() {
			super();
			MediaFiles = new Array();
			TrackingEvents = new Array();
			ClickTracking = new Array();
			CustomClicks = new Array();
		}
		
		override public function print(): void {
			super.print();
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
				var tracking: SATracking = TrackingEvents[t];
				trace("\tTrackingEvent[" + tracking.event + "]: " + tracking.URL);
			}
			for (var k: int = 0; k < MediaFiles.length; k++){
				var mediaFile:SAMediaFile = MediaFiles[k];
				trace("\tMedia[" + mediaFile.type + "] (" + mediaFile.width + "x" + mediaFile.height + "): " + mediaFile.URL);
			}
			trace("\tplayableMediaURL: " + playableMediaURL);
		}
		
		override public function sumCreative(creative: *):void {
			var linear:SALinearCreative = creative;
			super.sumCreative(linear);
			this.id = linear.id;
			this.sequence = linear.sequence;
			this.duration = linear.duration;
			
			if (linear.clickThrough) { this.clickThrough = linear.clickThrough; }
			if (linear.playableMediaURL) { this.playableMediaURL = linear.playableMediaURL; }
			
			this.MediaFiles = this.MediaFiles.concat(linear.MediaFiles);
			this.TrackingEvents = this.TrackingEvents.concat(linear.TrackingEvents);
			this.ClickTracking = this.ClickTracking.concat(linear.ClickTracking);
			this.CustomClicks = this.CustomClicks.concat(linear.CustomClicks);
		}
	}
}