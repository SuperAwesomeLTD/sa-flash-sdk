package  {
	
	import flash.display.MovieClip;
	import tv.superawesome.DisplayAd;
	import tv.superawesome.VideoAd;
	import flash.geom.Rectangle;

	public class Main extends MovieClip {
		
		
		public function Main() {
			// constructor code
			var vp:Rectangle = new Rectangle(0,0,320,50);
			var ad:DisplayAd = new DisplayAd(vp, "14", "5247930");
			addChild(ad);

			
			var vp2:Rectangle = new Rectangle(0,60,400,300);
			var vad:VideoAd = new VideoAd(vp2, "14", "314229");
			addChild(vad);
		}
	}
	
}
