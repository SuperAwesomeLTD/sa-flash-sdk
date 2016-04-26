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
		private var currentAdIndex:int = 0;
		private var currentCreativeIndex:int = -1;
		private var adQueue:Array = new Array();
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
		
		public function manageWithAds(ads: Array):void {
			// error case
			if (ads.length < 1) {
				if (delegate != null) {
					delegate.didNotFindAds();
				}
				return;
			}
			
			// copy ads
			adQueue = ads;
			
			// good case
			cAd = adQueue[currentAdIndex];
			
			// call delegate
			if (delegate != null) {
				delegate.didStartAd();
			}
			
			// progress through ads
			progressThroughAds();
		}
		
		public function parseVASTURL(url:String): void {
			parser = new SAVASTParser();
			parser.delegate = this;
			parser.parseVASTURL(url);
		}
		
		///////////////////////////////////////////////////////////////
		// Parser delegate
		///////////////////////////////////////////////////////////////
		
		public function didParseVAST(ads: Array): void {
			manageWithAds(ads);
		}
		
		///////////////////////////////////////////////////////////////
		// player delegate
		///////////////////////////////////////////////////////////////
		
		public function didFindPlayerReady(): void {
			if (!cAd.isImpressionSent) {
				for (var i:int = 0; i < cAd.Impressions.length; i++){
					SAEvents.sendEventToURL(cAd.Impressions[i]);
				}
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
			}
		}
		
		public function didPlayWithError(): void {
			
			if (delegate != null) {
				delegate.didHaveErrorForCreative();
			}
			
			// go forward if a creative is corrupted
			progressThroughAds();
		}
		
		public function didGoToURL(): void {
			var url:String = "";
			if (cCreative.clickThrough != null && SAUtils.isValidURL(cCreative.clickThrough)) {
				url = cCreative.clickThrough;
			}
			
			if (delegate != null) {
				delegate.didGoToURL(url, cCreative.ClickTracking);
			}
		}
		
		///////////////////////////////////////////////////////////////
		// Manager internal functions
		///////////////////////////////////////////////////////////////
		
		private function progressThroughAds(): void {
			playerRef.reset();
			var creativeCount:int = ((SAVASTAd)(adQueue[currentAdIndex])).Creatives.length;
			
			if (currentCreativeIndex < creativeCount - 1) {
				currentCreativeIndex++;
				cCreative = cAd.Creatives[currentCreativeIndex];
				
				// play the video
				playCurrentAdWithCurrentCreative();
			} else {
				if (delegate != null) {
					delegate.didEndAd();
				}
				
				if (currentAdIndex < adQueue.length - 1) {
					currentCreativeIndex = 0;
					currentAdIndex++;
					
					cAd = adQueue[currentAdIndex];
					cCreative = cAd.Creatives[currentCreativeIndex];
					
					if (delegate != null) {
						delegate.didStartAd();
					}
					
					// play
					playCurrentAdWithCurrentCreative();
				} else {
					// stop all
					playerRef.destroy();
					
					if (delegate != null) {
						delegate.didEndAllAds();
					}
				}
			}
		}
		
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