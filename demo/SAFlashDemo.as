package  {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import tv.superawesome.*;
	import tv.superawesome.Data.Loader.*;
	import tv.superawesome.Views.SAVideoAd;
	import tv.superawesome.Data.Models.*;
	import tv.superawesome.Views.SABannerAd;
	import flash.sampler.NewObjectSample;
	import tv.superawesome.Views.SAInterstitialAd;
	import tv.superawesome.Data.Loader.SALoaderProtocol;
	
	public class SAFlashDemo extends MovieClip implements SALoaderProtocol {

		public function SAFlashDemo() {
			// constructor code
			SuperAwesome.getInstance().disableTestMode();
			SuperAwesome.getInstance().setConfigurationProduction();
			SuperAwesome.getInstance().allowCrossdomain();
			
			SALoader.getInstance().delegate = this;
			SALoader.getInstance().loadAd(7223);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			var vad:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 320, 240));
			vad.setAd(ad);
			addChildAt(vad, 0);
			vad.play();
		}
		
		public function didFailToLoadAdForPlacementId(placementId: int): void {
			trace("failed to load ad");
		}
	}
}
