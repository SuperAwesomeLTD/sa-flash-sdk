package  {
	import flash.display.MovieClip;
	import tv.superawesome.SuperAwesome;
	import tv.superawesome.Views.*;
	import flash.geom.Rectangle;
	
	public class SADemo extends MovieClip implements SAVideoAdProtocol, SAViewProtocol {

		public function SADemo() {
			// constructor code
			
			SuperAwesome.getInstance().allowCrossdomain();
			SuperAwesome.getInstance().enableTestMode();
			
			
			/*var iad: SAInterstitialAd = new SAInterstitialAd(24408);
			iad.playInstant();
			addChild(iad);*/
			
			var bad: SABannerAd = new SABannerAd(new Rectangle(0,0,311,170), 21863);
			bad.maintainsAspectRatio = true;
			bad.playInstant();
			addChild(bad);
			
			/*var vad: SAVideoAd = new SAVideoAd(new Rectangle(0,0, 554, 311), 24532);
			vad.maintainsAspectRatio = false;
			addChild(vad);
			vad.playInstant();	*/
			
			var fvad: SAFullscreenVideoAd = new SAFullscreenVideoAd(24532);
			fvad.videoDelegate = this;
			fvad.delegate = this;
			fvad.playInstant();
			addChild(fvad);
		}
		
		public function adWasShown(placementId: int): void {
			trace("ad was shown");
		}
		public function adFailedToShow(placementId: int): void {
			trace("ad failed to show");
		}
		public function adWasClosed(placementId: int): void {
			trace("ad was closed");
		}
		public function adFollowedURL(placementId: int): void {
			trace("ad followed url");
		}
		
		public function videoStarted(placementId: int): void {
			trace("video started");
		}
		public function videoEnded(placementId:int): void {
			trace("video ended");
		}
		public function videoReachedFirstQuartile(placementId:int): void {
			trace("video 1/4");
		}
		public function videoReachedMidpoint(placementId:int): void {
			trace("video 1/2");
		}
		public function videoReachedThirdQuartile(placementId: int): void {
			trace("video 3/4");
		}
		public function videoSkipped(placementId: int): void {
			trace("video skipped");
		}
	}
}
