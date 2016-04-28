package tv.superawesome.sdk.Views {
	import flash.geom.Rectangle;
	
	import tv.superawesome.sdk.Models.SAAd;

	public interface SAViewInterface {
		
		// sets the ad for a SABannerAd, SAInterstitialAd, etc type class
		function setAd(ad:SAAd): void;
		
		// return an Ad
		function getAd():SAAd;
		
		// play the ad
		function play():void;
		
		// close the ad
		function close():void;
		
		// second pass at trying to go to URL
		function advanceToClick():void;
		
		// resize view or view controller
		function resizeToFrame(frame:Rectangle):void;
	}
}