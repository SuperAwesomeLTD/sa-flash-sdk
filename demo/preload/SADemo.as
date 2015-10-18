package  {
	import flash.display.MovieClip;
	import tv.superawesome.SuperAwesome;
	import tv.superawesome.Data.Loader.*;
	import tv.superawesome.Views.SABannerAd;
	import tv.superawesome.Views.SAVideoAd;
	import tv.superawesome.Data.Models.*;
	import flash.geom.Rectangle;
	
	public class SADemo extends MovieClip implements SALoaderProtocol{

		public var bad: SABannerAd;
		public var vad: SAVideoAd;
		
		public function SADemo() {
			// constructor code
			SALoader.getInstance().preloadAdForPlacementId(21863);
			SALoader.getInstance().preloadAdForPlacementId(21022);
			SALoader.getInstance().delegate = this;
			
			bad = new SABannerAd(new Rectangle(0,0,320,50));
			vad = new SAVideoAd(new Rectangle(0,100,370,270));
		}
		
		public function didPreloadAd(ad: SAAd, placementId:int): void {
			if (placementId == 21863) {
				bad.setAd(ad);
				bad.playPreloaded();
				addChild(bad);
			}
			else if (placementId == 21022) {
				vad.setAd(ad);
				vad.playPreloaded();
				addChild(vad);		
			}
		}
		
		public function didFailToPreloadAdForPlacementId(placementId:int): void{ 
			trace("Failed to load for ad: " + placementId);
		}
	}
	
}
