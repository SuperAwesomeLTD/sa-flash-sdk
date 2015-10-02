package  {
	// imports
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import tv.superawesome.*;
	
	// main class
	public class Main extends MovieClip {
		
		
		public function Main() {
			// set config
			SuperAwesome.getInstance().setConfigStaging();	
			
			// constructor code
			var vp:Rectangle = new Rectangle(0,0,320,50);
			var ad:BannerAd = new BannerAd(vp, 10001, true);
			addChild(ad);

			
			var vp2:Rectangle = new Rectangle(0,60,400,300);
			var vad:VideoAd = new VideoAd(vp2, 10002, true);
			addChild(vad);
			vad.play();
			
			var iad:InterstitialAd = new InterstitialAd(10029, true);
			addChild(iad);
			iad.play();
		}
	}
	
}
