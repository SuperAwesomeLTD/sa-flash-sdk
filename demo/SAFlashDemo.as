// package definition
package  {
	// generic flash imports
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	
	// superawesome imports
	import tv.superawesome.sdk.*;
	import tv.superawesome.sdk.Loader.*;
	import tv.superawesome.sdk.Views.SAVideoAd;
	import tv.superawesome.sdk.Models.*;
	import tv.superawesome.sdk.Loader.SALoaderInterface;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.libvideo.*;
	import tv.superawesome.libvast.SAVASTParser;
	import tv.superawesome.libvast.SAVASTManager;
	import tv.superawesome.sdk.Views.SAVideoAdInterface;
	import tv.superawesome.sdk.Views.SAAdInterface;
	import tv.superawesome.libvast.savastmodels.SAVASTAd;
	import tv.superawesome.sdk.Views.SABannerAd;
	
	public class SAFlashDemo extends MovieClip implements SAVideoAdInterface, SALoaderInterface, SAAdInterface {

		public function SAFlashDemo() {
			// display the SDK version to at least get an idea that I'm at the latest version
			trace(SuperAwesome.getInstance().getSdkVersion());
			
			// enable production & disable test mode
			SuperAwesome.getInstance().setConfigurationStaging();
			SuperAwesome.getInstance().disableTestMode();
			SuperAwesome.getInstance().allowCrossdomain();
			
			var loader:SALoader = new SALoader();
			loader.delegate = this;
			loader.loadAd(113);
			loader.loadAd(117);
			loader.loadAd(116);
		}
		
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			trace("loaded " + ad.placementId);
			if (ad.placementId == 117) {
				var vad:SAVideoAd = new SAVideoAd(new Rectangle(50, 100, 240, 160));
				vad.setAd(ad);
				vad.adDelegate = this;
				vad.videoDelegate = this;
				addChildAt(vad, 0);
				vad.play();
			}
			else if (ad.placementId == 116) {
				var vad2:SAVideoAd = new SAVideoAd(new Rectangle(300, 100, 200, 180));
				vad2.setAd(ad);
				addChildAt(vad2, 0);
				vad2.play();
			}
			else {
				var bad:SABannerAd = new SABannerAd(new Rectangle(50, 0, 420, 100));
				bad.setAd(ad);
				bad.adDelegate = this;
				addChildAt(bad, 0);
				bad.play();
			}
		}
		
		public function didFailToLoadAd(placementId: int): void {
			trace("didFailToLoadAdForPlacementId " + placementId);
		}
		
		public function adWasShown(placementId: int): void {
			trace("adWasShown");
		}
		
		public function adWasClosed(placementId: int): void {
			trace("adWasClosed");
		}
		
		public function adWasClicked(placementId: int): void {
			trace("adWasClicked");
		}
		
		public function adFailedToShow(placementId: int): void {
			trace("adFailedToShow");
		}
		
		public function adHasIncorrectPlacement(placementId: int): void {
			trace("adHasIncorrectPlacement");
		}

		public function adStarted(placementId: int): void {
			trace("adStarted");
		}
		
		public function videoStarted(placementId: int): void {
			trace("videoStarted");
		}
		
		public function videoReachedFirstQuartile(placementId: int): void {
			trace("videoReachedFirstQuartile");
		}
		
		public function videoReachedMidpoint(placementId: int): void {
			trace("videoReachedMidpoint");
		}
		
		public function videoReachedThirdQuartile(placementId: int): void {
			trace("videoReachedThirdQuartile");
		}
		
		public function videoEnded(placementId: int):void {
			trace("videoEnded");
		}
		
		public function adEnded(placementId: int):void {
			trace("adEnded");
		}
		public function allAdsEnded(placementId: int):void {
			trace("allAdsEnded");
		}
	}
}
