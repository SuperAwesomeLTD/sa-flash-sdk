//
//  SAVideoAd.h
//  tv.superawesome.Views
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//
package tv.superawesome.Views {
	
	// imports
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
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	import tv.superawesome.Data.Models.SACreativeFormat;
	import tv.superawesome.Views.SAView;
	import tv.superawesome.Views.Protocols.SAVideoAdProtocol;
	
	// subclass of SAView that is used to render video ads
	// with help from Google IMA SDK
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
		
		// local implementation of play() function
		public override function play(): void {	
			
			// check for incorrect format
			if (ad.creative.format != SACreativeFormat.video) {
				if (this.adDelegate != null) {
					this.adDelegate.adHasIncorrectPlacement(ad.placementId);
				}
				return;
			}
			
			// start displaying
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
			adsLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, adsLoadErrorHandler);
			adsLoader.requestAds(adsRequest);
			
			// call success
			success();
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
				
				adsManager.handshakeVersion("1.0");
				adsManager.init(videoFrame.width, videoFrame.height, ViewModes.IGNORE);
				
				adsManager.adsContainer.x = videoFrame.x;
				adsManager.adsContainer.y = videoFrame.y;
				
				DisplayObjectContainer(videoPlayer.videoDisplay.parent).addChild(adsManager.adsContainer);
				
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
			videoPlayer.play();
			error();
		}
		
		private function adsManagerPlayErrorHandler(event:AdErrorEvent):void {
			destroyAdsManager();
			videoPlayer.play();
			error();
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
			if (super.adDelegate != null) {
				super.adDelegate.adWasClosed(ad.placementId);
			}
		}
	}
}
