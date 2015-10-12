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
			
			///////////////////////////////////////////////////////
			// Create the Banner ad
			var ad:BannerAd = new BannerAd(new Rectangle(0,0,320,50), 21156);
			ad.onAdLoad(function() {
				trace("banner loaded");
			});
			ad.onAdFail(function(){
				trace("banner failed");
			});
			ad.onAdClose(function() {
				trace("banner close");
			});
			ad.onAdEmpty(function(){
				trace("banner empty");
			});
			addChild(ad);
			ad.play();

			///////////////////////////////////////////////////////
			// Create the Video ad
			var vad:VideoAd = new VideoAd(new Rectangle(0,60,400,300), 21278);
			vad.onAdLoad(function(){
				trace("video loaded");
			});
			vad.onAdFail(function(){
				trace("video failed");
			});
			vad.onAdClose(function() {
				trace("video closed");
			});
			vad.onAdEmpty(function(){
				trace("video empty");
			});
			addChild(vad);
			vad.play();
			
			///////////////////////////////////////////////////////
			// Create the Interstitial ad
			var iad:InterstitialAd = new InterstitialAd(21277);
			iad.onAdLoad(function(){
				trace("interstitial loaded");
			});
			iad.onAdFail(function() {
				trace("interstitial failed");
			});
			iad.onAdClose(function() {
				trace("interstitial closed");
			});
			iad.onAdEmpty(function(){
				trace("interstitial empty");
			});
			addChild(iad);
			iad.play();
		}
	}
}
