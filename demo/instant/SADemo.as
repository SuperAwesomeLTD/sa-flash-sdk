﻿package  {
	import flash.display.MovieClip;
	import tv.superawesome.SuperAwesome;
	import tv.superawesome.Views.*;
	import flash.geom.Rectangle;
	
	public class SADemo extends MovieClip{

		public function SADemo() {
			// constructor code
			
			SuperAwesome.getInstance().allowCrossdomain();
			SuperAwesome.getInstance().disableTestMode();
			
			
			/*var iad: SAInterstitialAd = new SAInterstitialAd(24408);
			iad.playInstant();
			addChild(iad);
			
			var bad: SABannerAd = new SABannerAd(new Rectangle(0,0,310,70), 21863);
			bad.playInstant();
			addChild(bad);*/
			
			var vad: SAVideoAd = new SAVideoAd(new Rectangle(0,0, 554, 311), 24532);
			vad.maintainsAspectRatio = true;
			addChild(vad);
			vad.playInstant();	
		}
	}
}
