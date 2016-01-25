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
			
			SuperAwesome.getInstance().setConfigurationProduction();
			// SuperAwesome.getInstance().allowCrossdomain();
			trace("here");
			
			SALoader.getInstance().delegate = this;
			SuperAwesome.getInstance().enableTestMode();
			SALoader.getInstance().loadAd(9549);
			SuperAwesome.getInstance().disableTestMode();
			SALoader.getInstance().loadAd(24720);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			if (ad.placementId == 9549) {
				var bad: SABannerAd = new SABannerAd(new Rectangle(0, 0, 240, 240));
				bad.setAd(ad);
				bad.adDelegate = this;
				addChild(bad);
				bad.play();
			} else {
				var vad2:SAVideoAd = new SAVideoAd(new Rectangle(240,0,240,240));
				vad2.setAd(ad);
				vad2.adDelegate = this;
				addChildAt(vad2, 0);
				vad2.play();
			}
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
