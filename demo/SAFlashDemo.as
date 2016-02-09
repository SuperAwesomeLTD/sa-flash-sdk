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
				vad.adDelegate = this;
				addChildAt(vad, 0);
				vad.play();
			}
		}
		
		public function didFailToLoadAdForPlacementId(placementId: int): void {
			trace("failed to load ad " + placementId);
		}
		
		public function adWasShown(placementId: int): void {
			trace(placementId + " adWasShown");
		}
		
		public function adFailedToShow(placementId: int): void {
			trace(placementId + " adFailedToShow");
		}
		
		public function adWasClosed(placementId: int): void {
			trace(placementId + " adWasClosed");	
		}
		
		public function adWasClicked(placementId: int): void {
			trace(placementId + " adWasClicked");	
		}
		
		public function adHasIncorrectPlacement(placementId: int): void {
			trace(placementId + " adHasIncorrectPlacement");
		}
	}
}
