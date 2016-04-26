﻿// package definition
package  {
	// generic flash imports
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.events.AsyncErrorEvent;
	
	// superawesome imports
	import tv.superawesome.sdk.*;
	import tv.superawesome.sdk.Loader.*;
	import tv.superawesome.sdk.Views.SAVideoAd;
	import tv.superawesome.sdk.Models.*;
	import tv.superawesome.sdk.Views.SABannerAd;
	import tv.superawesome.sdk.Views.SAInterstitialAd;
	import tv.superawesome.sdk.Loader.SALoaderInterface;
	import tv.superawesome.sdk.Views.SAAdProtocol;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.libvideo.*;
	import tv.superawesome.libvast.SAVASTParser;
	import tv.superawesome.libvast.SAVASTManager;
	import flash.events.NetStatusEvent;
	
	// notice here the SAFlashDemo class implements both:
	// SALoaderProtocol
	// SAAdProtocol
	public class SAFlashDemo extends MovieClip implements SALoaderInterface, SAAdProtocol, SAVideoPlayerInterface {

		public function SAFlashDemo() {
			// display the SDK version to at least get an idea that I'm at the latest version
			trace(SuperAwesome.getInstance().getSdkVersion());
			
			// enable production & disable test mode
			SuperAwesome.getInstance().setConfigurationProduction();
			SuperAwesome.getInstance().enableTestMode();
			SuperAwesome.getInstance().allowCrossdomain();
			
			var loader:SALoader = new SALoader();
			loader.delegate = this;
			loader.loadAd(28000);
			
			// make "this" my SALoader delegate and load my ad
			// SALoader.getInstance().delegate = this;
			// SALoader.getInstance().loadAd(2558);
			
			// var parser:SAVASTParser = new SAVASTParser();
			// parser.parseVASTURL("https://ads.superawesome.tv/v2/video/vast/31210/31519/31702/?sdkVersion=unknown&rnd=139212695");
			
			// SAVASTParser.parseVASTURL("https://ads.superawesome.tv/v2/video/vast/28000/-1/-1/?sdkVersion=unknown&rnd=643079622");
			// SAVASTParser.parseVASTURL("https://ads.staging.superawesome.tv/v2/video/vast/79/336/554/?sdkVersion=unknown&rnd=91820873");
			// SAVASTParser.parseVASTURL("https://ads.superawesome.tv/v2/video/vast/31210/31519/31702/?sdkVersion=unknown&rnd=139212695");
			
			var player:SAVideoPlayer = new SAVideoPlayer(new Rectangle(100, 50, 320, 180));
			this.addChild(player);
			// var url1 = "https://ads.superawesome.tv/v2/demo_images/video.mp4";
			// var url2 = "https://sa-beta-ads-video-transcoded-superawesome.netdna-ssl.com/dYzJz82NqdUvVcPcQlBQmHL1z6ftRz5f.mp4";
			// var url3 = "https://s-static.innovid.com/assets/26156/32233/encoded/media-1.flv";
			player.delegate = this;
			// player.playWithMediaURL(url1);
			
			var manager:SAVASTManager = new SAVASTManager(player);
			manager.parseVASTURL("https://ads.superawesome.tv/v2/video/vast/31210/31519/31702/?sdkVersion=unknown&rnd=139212695");
			
		}
		
		// 
		// implement the "didLoadAd", function; 
		// here I can "print()" the ad for debugging
		// and setup my video ad
		//
		// I can also now decide, if the Ad is a fallback, to ignore it
		public function didLoadAd(ad: SAAd): void {
			ad.print();
			
			//if (ad.isFallback) {
			//	// Ad is fallback and I can ignore it if I choose
			//} else {
			//	var vad:SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 240, 240));
			//	vad.setAd(ad);
			//	// This is very important: set the current video's "adDelegate" object
			//	// to this so that the video can send important messages / callbacks to
			//	// the current object!
			//	vad.adDelegate = this;
			//	addChildAt(vad, 0);
			//	vad.play();
			//}
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
		
		public function didFailToLoadAd(placementId: int): void {
			// Here is one moment when you can catch an error happening and display the 
			// "no video available" message
			// 
			// this callback is usually called when the ad data is empty (json response is "{}")
			// or corrupt in some way (video ad might not have a video .mp4 / .swf URL attached, etc)
			trace("didFailToLoadAdForPlacementId " + placementId);
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
		
		public function didFindPlayerReady(): void {
			trace("didFindPlayerReady");
		}
		
		public function didStartPlayer(): void {
			trace("didStartPlayer");
		}
		
		public function didReachFirstQuartile(): void {
			trace("didReachFirstQuartile");
		}
		
		public function didReachMidpoint(): void {
			trace("didReachMidpoint");
		}
		
		public function didReachThirdQuartile(): void {
			trace("didReachThirdQuartile");
		}
		
		public function didReachEnd(): void {
			trace("didReachEnd");
		}
		
		public function didPlayWithError(): void {
			trace("didPlayWithError");
		}
		
		public function didGoToURL(): void {
			trace("didGoToURL");
		}
	}
}
