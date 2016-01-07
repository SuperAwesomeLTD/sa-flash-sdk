package  {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import tv.superawesome.*;
	import tv.superawesome.Data.Loader.*;
	import tv.superawesome.Views.SAVideoAd;
	import tv.superawesome.Data.Models.*;
	import tv.superawesome.System.*;
	import tv.superawesome.Views.SABannerAd;
	import flash.sampler.NewObjectSample;
	import tv.superawesome.Views.SAInterstitialAd;
	import tv.superawesome.Data.Loader.SALoaderProtocol;
	import tv.superawesome.Views.Protocols.SAVideoAdProtocol;
	import tv.superawesome.Views.Protocols.SAAdProtocol;
	
	public class SAFlashDemo extends MovieClip implements SALoaderProtocol, SAAdProtocol, SAVideoAdProtocol {

		private var vad1:SAVideoAd;
		
		public function SAFlashDemo() {
			// constructor code
			trace(SuperAwesome.getInstance().getSdkVersion());
			trace(SASystem.getSystemType() + "_" + SASystem.getSystemSize());
			
			SuperAwesome.getInstance().allowCrossdomain();
			SuperAwesome.getInstance().disableTestMode();
			SuperAwesome.getInstance().setConfigurationProduction();
			
			SALoader.getInstance().delegate = this;
			SALoader.getInstance().loadAd(24720);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			vad1 = new SAVideoAd(new Rectangle(0, 0, 240, 240));
			vad1.setAd(ad);
			vad1.videoDelegate = this;
			addChildAt(vad1, 0);
			vad1.play();
		}
		
		public function didFailToLoadAdForPlacementId(placementId: int): void {
			trace("failed to load ad " + placementId);
		}
		
		public function adWasShown(placementId: int): void {
			trace(placementId + " adWasShown");
		}
		
		public function adFailedToShow(placementId: int): void {
			trace(placementId + " adFailedToShow");
		}
		
		public function adWasClosed(placementId: int): void {
			trace(placementId + " adWasClosed");	
		}
		
		public function adWasClicked(placementId: int): void {
			trace(placementId + " adWasClicked");	
		}
		
		public function adHasIncorrectPlacement(placementId: int): void {
			trace(placementId + " adHasIncorrectPlacement");
		}
		
		public function videoStarted(placementId: int): void {
			
		}
		
		public function videoReachedFirstQuartile(placementId:int): void {
			
		}
		
		public function videoReachedMidpoint(placementId:int): void {
			
		}
		
		public function videoReachedThirdQuartile(placementId: int): void {
			
		}
		
		public function videoEnded(placementId:int): void {
			trace("video " + placementId + " ended");
			this.removeChild(vad1);
		}
	}
}
