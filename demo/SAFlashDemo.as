package  {
	
	import flash.display.MovieClip;
	import tv.superawesome.*;
	import tv.superawesome.Views.SABannerAd;
	import flash.geom.Rectangle;
	import tv.superawesome.Views.SAVideoAd;
	import tv.superawesome.Views.SAInterstitialAd;
	import tv.superawesome.Views.SAFullscreenVideoAd;
	
	public class SAFlashDemo extends MovieClip {

		public function SAFlashDemo() {
			// constructor code
			SuperAwesome.getInstance().enableTestMode();
			SuperAwesome.getInstance().setConfigurationProduction();
			
			/*var bad: SABannerAd = new SABannerAd(new Rectangle(10, 10, 320, 150), 21636);
			bad.playInstant();
			addChild(bad);*/
			
			/*var iad: SAInterstitialAd = new SAInterstitialAd(21924);
			iad.playInstant();
			addChild(iad);*/
			
			var vad: SAVideoAd = new SAVideoAd(new Rectangle(30, 80, 320, 300), 21022);
			vad.playInstant();
			addChild(vad);
			
			/**var fvad: SAFullscreenVideoAd = new SAFullscreenVideoAd(21022);
			fvad.playInstant();
			addChild(fvad);*/
		}

	}
	
}
