// package definition
package  {
	// generic flash imports
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	
	// superawesome imports
	import tv.superawesome.*;
	import tv.superawesome.Data.Loader.*;
	import tv.superawesome.Views.SAVideoAd;
	import tv.superawesome.Data.Models.*;
	import tv.superawesome.System.*;
	import tv.superawesome.Views.SABannerAd;
	import tv.superawesome.Views.SAInterstitialAd;
	import tv.superawesome.Data.Loader.SALoaderProtocol;
	import tv.superawesome.Views.Protocols.SAAdProtocol;
	
	// notice here the SAFlashDemo class implements both:
	// SALoaderProtocol
	// SAAdProtocol
	public class SAFlashDemo extends MovieClip implements SALoaderProtocol, SAAdProtocol {

		public function SAFlashDemo() {
			// display the SDK version to at least get an idea that I'm at the latest version
			trace(SuperAwesome.getInstance().getSdkVersion());
			trace(SASystem.getSystemType() + "_" + SASystem.getSystemSize());
			
			// enable production & disable test mode
			SuperAwesome.getInstance().setConfigurationProduction();
			SuperAwesome.getInstance().disableTestMode();
			
			// make "this" my SALoader delegate and load my ad
			SALoader.getInstance().delegate = this;
			SALoader.getInstance().loadAd(24720);
		}
		
		// 
		// implement the "didLoadAd", function; 
		// here I can "print()" the ad for debugging
		// and setup my video ad
		//
		// I can also now decide, if the Ad is a fallback, to ignore it
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			if (ad.isFallback) {
				// Ad is fallback and I can ignore it if I choose
			} else {
				var vad:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 240, 240));
				vad.setAd(ad);
				// This is very important: set the current video's "adDelegate" object
				// to this so that the video can send important messages / callbacks to
				// the current object!
				vad.adDelegate = this;
				addChildAt(vad, 0);
				vad.play();
			}
		}
		
		public function adWasShown(placementId: int): void {
			// if all goes well, when this is called the ad is displayed, runs, etc
		}
		
		public function adWasClosed(placementId: int): void {
			// not really that useful 	
		}
		
		public function adWasClicked(placementId: int): void {
			// catch clicks
		}
		
		////////////////////////////////////
		// All these three callbacks deals with some kind of error
		// that might happen with the Ad, so it's good to implement them
		// and respond accordingly
		////////////////////////////////////
		
		public function didFailToLoadAdForPlacementId(placementId: int): void {
			// Here is one moment when you can catch an error happening and display the 
			// "no video available" message
			// 
			// this callback is usually called when the ad data is empty (json response is "{}")
			// or corrupt in some way (video ad might not have a video .mp4 / .swf URL attached, etc)
		}
		
		public function adFailedToShow(placementId: int): void {
			// Here is the second important moment when you can catch an error occuring and
			// display the "no video available" message
			//
			// this gets called for example when an Ad was able to load, but, for some reason:
			// - the vast tag is invalid or empty
			// - the vast tag is OK but there is no media attached
			// - vast is ok, media is OK but unreachable because of some reason
		}
		
		public function adHasIncorrectPlacement(placementId: int): void {
			// Here is the third important moment when you can catch an error occuring and
			// display the "no video available" message
			// 
			// This callback only handles cases when, for some reason or another, an image type ads
			// get sent to be displayed in a video ad type object - should happen very rarely, but
			// it's good to have it around
		}
	}
}
