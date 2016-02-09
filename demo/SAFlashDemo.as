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
	import tv.superawesome.Views.Protocols.SAAdProtocol;
	
	public class SAFlashDemo extends MovieClip implements SALoaderProtocol, SAAdProtocol {

		public function SAFlashDemo() {
			// constructor code
			trace(SuperAwesome.getInstance().getSdkVersion());
			trace(SASystem.getSystemType() + "_" + SASystem.getSystemSize());
			
			SuperAwesome.getInstance().setConfigurationDevelopment();
			// SuperAwesome.getInstance().allowCrossdomain();
			// trace("here");
			
			SALoader.getInstance().delegate = this;
			SuperAwesome.getInstance().disableTestMode();
			SALoader.getInstance().loadAd(5);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			var vad:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 240, 240));
			vad.setAd(ad);
			vad.adDelegate = this;
			addChildAt(vad, 0);
			vad.play();
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
	}
}
