package  {
	import flash.display.MovieClip;
	import tv.superawesome.SuperAwesome;
	import tv.superawesome.Views.*;
	import flash.geom.Rectangle;
	
	public class SADemo extends MovieClip{

		public function SADemo() {
			// constructor code
			
			SuperAwesome.getInstance().allowCrossdomain();
			
			
			var iad: SAInterstitialAd = new SAInterstitialAd(24408);
			iad.playInstant();
			addChild(iad);
			
			/*var bad: SABannerAd = new SABannerAd(new Rectangle(0,0,320,50), 21863);
			bad.playInstant();
			addChild(bad);
			
			var vad: SAVideoAd = new SAVideoAd(new Rectangle(0,100, 320, 270), 21022);
			addChild(vad);
			vad.playInstant();	*/	
		}
	}
}
