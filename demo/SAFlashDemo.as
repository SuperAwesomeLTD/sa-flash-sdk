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
	
	public class SAFlashDemo extends MovieClip implements SALoaderProtocol {

		public function SAFlashDemo() {
			// constructor code
			trace(SuperAwesome.getInstance().sdkVersion());
			trace(SASystem.getSystemType() + "_" + SASystem.getSystemSize());
			
			SuperAwesome.getInstance().disableTestMode();
			SuperAwesome.getInstance().setConfigurationProduction();
			SuperAwesome.getInstance().allowCrossdomain();
			
			SALoader.getInstance().delegate = this;
			SALoader.getInstance().loadAd(24532);
			SALoader.getInstance().loadAd(24720);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			if (ad.placementId == 24532) {
				var vad1:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 240, 240));
				vad1.setAd(ad);
				addChildAt(vad1, 0);
				vad1.play();
			} else {
				var vad2:SAVideoAd = new SAVideoAd(new Rectangle(240,0,240,240));
				vad2.setAd(ad);
				addChildAt(vad2, 0);
				vad2.play();
			}
		}
		
		public function didFailToLoadAdForPlacementId(placementId: int): void {
			trace("failed to load ad " + placementId);
		}
	}
}
