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
			
			SuperAwesome.getInstance().disableTestMode();
			SuperAwesome.getInstance().setConfigurationProduction();
			
			SALoader.getInstance().delegate = this;
			SALoader.getInstance().loadAd(24532);
			SALoader.getInstance().loadAd(24720);
			// SALoader.getInstance().loadAd(5692);
			/*SALoader.getInstance().loadAd(24720);*/
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			if (ad.placementId == 24532) {
				var vad1:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 240, 240));
				vad1.setAd(ad);
				addChildAt(vad1, 0);
				vad1.play();
			} else if (ad.placementId == 24720) {
				var vad2:SAVideoAd = new SAVideoAd(new Rectangle(240,0,240,240));
				vad2.setAd(ad);
				addChildAt(vad2, 0);
				vad2.play();
			} else if (ad.placementId == 5692){
				var iad:SAInterstitialAd = new SAInterstitialAd();
				iad.setAd(ad);
				iad.adDelegate = this;
				addChild(iad);
				iad.play();
			} else if (ad.placementId == 5687) {
				var bad:SABannerAd = new SABannerAd(new Rectangle(0, 0, 250, 130));
				bad.setAd(ad);
				addChild(bad);
				bad.play();
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
