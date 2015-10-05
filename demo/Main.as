package  {
	// imports
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import tv.superawesome.*;
	
	// main class
	public class Main extends MovieClip {
		
		
		public function Main() {
			// set config
			SuperAwesome.getInstance().setConfigProduction();
			SuperAwesome.getInstance().enableTestMode();
			
			// constructor code
			var vp:Rectangle = new Rectangle(0,0,320,50);
			var ad:BannerAd = new BannerAd(vp, 5687);
			addChild(ad);

			
			var vp2:Rectangle = new Rectangle(0,60,400,300);
			var vad:VideoAd = new VideoAd(vp2, 5740);
			addChild(vad);
			vad.play();
			
			var iad:InterstitialAd = new InterstitialAd(5692);
			addChild(iad);
			iad.play();
		}
	}
	
}
