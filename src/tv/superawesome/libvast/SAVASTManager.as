package tv.superawesome.libvast {
	
	// imports
	import tv.superawesome.libevents.SAEvents;
	import tv.superawesome.libvast.SAVASTParser;
	import tv.superawesome.libvast.SAVASTParserInterface;
	import tv.superawesome.libvast.savastmodels.SAVASTAd;
	import tv.superawesome.libvast.savastmodels.SAVASTCreative;
	import tv.superawesome.libvast.savastmodels.SAVASTTracking;
	import tv.superawesome.libvideo.SAVideoPlayer;
	import tv.superawesome.libvideo.SAVideoPlayerInterface;
	import tv.superawesome.libutils.SAUtils;
	
	//
	// the main vast manager object
	public class SAVASTManager implements SAVASTParserInterface, SAVideoPlayerInterface {
		// reference to the vidoe player
		private var playerRef:SAVideoPlayer = null;
		private var parser:SAVASTParser = null;
		
		// vars for the manager
		private var cAd:SAVASTAd = null;
		private var cCreative:SAVASTCreative = null;
		
		// delegate
		public var delegate:SAVASTManagerInterface = null;
		
		public function SAVASTManager(player:SAVideoPlayer) {
			super();
			// assign
			playerRef = player;
			playerRef.delegate = this;
		}
		
		public function manageWithAd(ad: SAVASTAd):void {
			// error case
			if (!ad || !ad.creative) {
				if (delegate != null) {
					delegate.didNotFindAds();
				}
				return;
			}
			
			// good case
			cAd = ad;
			cCreative = ad.creative;
			
			// call delegate
			if (delegate != null) {
				delegate.didStartAd();
			}
			
			playerRef.reset();
			playCurrentAdWithCurrentCreative();
		}
		
		public function parseVASTURL(url:String): void {
			parser = new SAVASTParser();
			parser.delegate = this;
			parser.parseVASTURL(url);
		}
		
		///////////////////////////////////////////////////////////////
		// Parser delegate
		///////////////////////////////////////////////////////////////
		
		public function didParseVAST(ad: SAVASTAd): void {
			manageWithAd(ad);
		}
		
		///////////////////////////////////////////////////////////////
		// player delegate
		///////////////////////////////////////////////////////////////
		
		public function didFindPlayerReady(): void {
			for (var i:int = 0; i < cAd.Impressions.length; i++){
				SAEvents.sendEventToURL(cAd.Impressions[i]);
			}
		}
		
		public function didStartPlayer(): void {
			
			sendCurrentCreativeTrackersFor("start");
			sendCurrentCreativeTrackersFor("creativeView");
			
			if (delegate != null) {
				delegate.didStartCreative();
			}
		}
		
		public function didReachFirstQuartile(): void {
			
			sendCurrentCreativeTrackersFor("firstQuartile");
			
			if (delegate != null) {
				delegate.didReachFirstQuartileOfCreative();
			}
		}
		
		public function didReachMidpoint(): void {
			
			sendCurrentCreativeTrackersFor("midpoint");
			
			if (delegate != null) {
				delegate.didReachMidpointOfCreative();
			}
		}
		
		public function didReachThirdQuartile(): void {
			
			sendCurrentCreativeTrackersFor("thirdQuartile");
			
			if (delegate != null) {
				delegate.didReachThirdQuartileOfCreative();
			}
		}
		
		public function didReachEnd(): void {
			
			sendCurrentCreativeTrackersFor("complete");
			
			if (delegate != null) {
				delegate.didEndOfCreative();
				delegate.didEndAd();
				delegate.didEndAllAds();
			}
		}
		
		public function didPlayWithError(): void {
			
			if (delegate != null) {
				delegate.didHaveErrorForCreative();
			}
		}
		
		public function didGoToURL(): void {
			var url:String = "";
			if (cCreative.clickThrough != null /* && SAUtils.isValidURL(cCreative.clickThrough)*/) {
				url = cCreative.clickThrough;
			}
			
			if (delegate != null) {
				delegate.didGoToURL(url, cCreative.ClickTracking);
			}
		}
		
		///////////////////////////////////////////////////////////////
		// Manager internal functions
		///////////////////////////////////////////////////////////////
		
		private function playCurrentAdWithCurrentCreative(): void {
			playerRef.delegate = this;
			playerRef.playWithMediaURL(cCreative.playableMediaURL);
		}
		
		private function sendCurrentCreativeTrackersFor(event:String): void {
			var trackers:Array = new Array();
			for (var i:int = 0; i < cCreative.TrackingEvents.length; i++){
				var tracker:SAVASTTracking = (SAVASTTracking)(cCreative.TrackingEvents[i]);
				if (tracker.event == event) {
					trackers.push(tracker.URL);
				}
			}
			
			for (var j:int = 0; j < trackers.length; j++){
				SAEvents.sendEventToURL(trackers[j]);
			}
		}
	}
}