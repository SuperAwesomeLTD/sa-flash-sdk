// ActionScript file

package tv.superawesome.Views {
	
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flash.display.SimpleButton;
	
	import tv.superawesome.Data.Sender.SASender;
	import tv.superawesome.Views.SAVideoAdProtocol;
	import tv.superawesome.Views.SAView;
	
	public class SAVideoAd extends SAView {
		// private internal vars
		private var background: Sprite;
		private var contentPlayheadTime:Number;
		private var adsLoader: AdsLoader;
		private var adsManager: AdsManager;
		private var videoPlayer: VideoPlayerFlex3;
		private var videoFrame: Rectangle;
		private var clickThroughURL: String;
		
		// oublic vars
		public var videoDelegate: SAVideoAdProtocol;
		
		// constructors
		public function SAVideoAd(frame: Rectangle) {
			// call to super
			super(frame);
		}
		
		public override function play(): void {	
			if (this.stage != null) delayedDisplay();
			else this.addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void {
			// get background img
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = super.frame.x;
			background.y = super.frame.y;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			// resize video
			videoFrame = super.frame;
			
			videoPlayer = new VideoPlayerFlex3(new Video(), this, videoFrame, null, null, null, null, null);
			videoPlayer.contentUrl = ad.creative.details.video;
			
			var adsRequest: AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = super.ad.creative.details.vast;
			adsRequest.linearAdSlotWidth = videoFrame.width;
			adsRequest.linearAdSlotHeight = videoFrame.height;
			adsRequest.nonLinearAdSlotWidth = videoFrame.width;
			adsRequest.nonLinearAdSlotHeight = videoFrame.height;
			
			adsLoader = new AdsLoader();
			adsLoader.loadSdk();
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED, adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			adsLoader.requestAds(adsRequest);
			
			// call success
			success();
			
			// remove listener
//			e.target.removeEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void {
			// create content playhead
			var contentPlayhead:Object = {};
			contentPlayhead.time = function():Number { return contentPlayheadTime * 1000; };
			
			// create manager with rendering settings
			var adsRenderingSettings:AdsRenderingSettings = new AdsRenderingSettings();
			adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
			
			if (adsManager) {
				// add event listeners
				adsManager.addEventListener(AdEvent.LOADED, adsManagerAdLoadedHandler);
				adsManager.addEventListener(AdEvent.STARTED, adsManagerStartedHandler);
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED, allAdsCompletedHandler);
				adsManager.addEventListener(AdErrorEvent.AD_ERROR, adsManagerPlayErrorHandler);
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED, adsManagerContentPauseRequestedHandler);
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED, adsManagerContentResumeRequestedHandler);
				adsManager.addEventListener(AdEvent.FIRST_QUARTILE, adsManagerFirstQuartileHandler);
				adsManager.addEventListener(AdEvent.MIDPOINT, adsManagerMidpointHandler);
				adsManager.addEventListener(AdEvent.THIRD_QUARTILE, adsManagerThirdQuartileHandler);
				adsManager.addEventListener(AdEvent.CLICKED, adsManagerOnClick);
				
				adsManager.handshakeVersion("1.0");
				adsManager.init(videoFrame.width, videoFrame.height, ViewModes.IGNORE);
				
				adsManager.adsContainer.x = videoFrame.x;
				adsManager.adsContainer.y = videoFrame.y;
				
				DisplayObjectContainer(videoPlayer.videoDisplay.parent).addChild(adsManager.adsContainer);
				
				adsManager.adsContainer.mouseEnabled = false;
				adsManager.adsContainer.mouseChildren = false;
				
				// create "click" button
				var myButtonSprite:Sprite = new Sprite();
				myButtonSprite.graphics.beginFill(0xff000,0);
				myButtonSprite.graphics.drawRect(videoFrame.x,videoFrame.y,videoFrame.width,videoFrame.height);
				myButtonSprite.graphics.endFill();
				
				var goButton: SimpleButton = new SimpleButton();
				goButton.overState = goButton.downState = goButton.upState = goButton.hitTestState = myButtonSprite;
				goButton.addEventListener(MouseEvent.CLICK, adsManagerOnClick);
				this.addChild(goButton);
				
				// start add manager
				adsManager.start();
			}
		}
		
		private function adsManagerAdLoadedHandler(event:AdEvent): void {
			// loaded
		}
		
		private function adsManagerStartedHandler(event:AdEvent): void {
			if (videoDelegate != null) {
				videoDelegate.videoStarted(ad.placementId);
			}
		}
		
		private function adsManagerContentPauseRequestedHandler(event:AdEvent): void {
			// not in use	
		}
		
		private function adsManagerContentResumeRequestedHandler(event:AdEvent): void {
			// not in use
		}
		
		private function adsManagerFirstQuartileHandler(event:AdEvent): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedFirstQuartile(ad.placementId);
			}
		}
		
		private function adsManagerMidpointHandler(event:AdEvent): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedMidpoint(ad.placementId);
			}
		}
		
		private function adsManagerThirdQuartileHandler(event:AdEvent): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedThirdQuartile(ad.placementId);
			}
		}
		
		private function allAdsCompletedHandler(event:AdEvent):void {
			destroyAdsManager();
			
			if (videoDelegate != null) {
				videoDelegate.videoEnded(ad.placementId);
			}
		}
		
		private function adsLoadErrorHandler(event:AdErrorEvent):void {
			trace("error!!!");
			videoPlayer.play();
			error();
		}
		
		private function adsManagerPlayErrorHandler(event:AdErrorEvent):void {
			destroyAdsManager();
			videoPlayer.play();
			error();
		}
		
		private function adsManagerOnClick(event: MouseEvent): void {
			goToURL(event);
//			
//			// don't do this
//			trace(this.ad.creative.clickURL);
//			var clickURL: URLRequest = new URLRequest(this.ad.creative.clickURL);
//			navigateToURL(clickURL, "_blank");
//			
////			if (super.delegate != null) {
////				super.delegate.adWasClicked(ad.placementId);
////			}
		}
		
		// some other aux functions
		
		private function destroyAdsManager():void {
			if (adsManager) {
				if (adsManager.adsContainer.parent &&
					adsManager.adsContainer.parent.contains(adsManager.adsContainer)) {
					adsManager.adsContainer.parent.removeChild(adsManager.adsContainer);
				}
				adsManager.destroy();
			}
		}
	
		public function closeAd(): void {
			// stop this
			destroyAdsManager();
			
			// call remove child
			this.parent.removeChild(this);
			
			// call delegate
			if (super.delegate != null) {
				super.delegate.adWasClosed(ad.placementId);
			}
		}
	}
}
