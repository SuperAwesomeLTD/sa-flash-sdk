package tv.superawesome.sdk.Views {
	
	// imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import tv.superawesome.libevents.SAEvents;
	import tv.superawesome.libvast.SAVASTManager;
	import tv.superawesome.libvast.SAVASTManagerInterface;
	import tv.superawesome.libvideo.SAVideoPlayer;
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.sdk.Models.SACreativeFormat;
	import tv.superawesome.sdk.Views.SAViewInterface;
	
	public class SAVideoAd extends Sprite implements SAViewInterface, SAVASTManagerInterface {
		
		// private var
		private var ad:SAAd = null;
		private var frame:Rectangle;
		private var player:SAVideoPlayer = null;
		private var manager:SAVASTManager = null;
		
		// aux vars
		private var destinationUrl:String = null;
		private var trackingArray:Array = new Array();
		
		// public vars
		public var adDelegate:SAAdInterface = null;
		public var videoDelegate:SAVideoAdInterface = null;
		public var shouldShowSmallClickButton:Boolean = false;
		
		// watermark
		private var watermark: Loader = new Loader();
		
		public function SAVideoAd(frame: Rectangle){
			super();
			this.frame = frame;
		}
		
		// SAViewInterface implementation
		
		public function setAd(ad:SAAd): void {
			this.ad = ad;
		}
		
		public function getAd():SAAd {
			return ad;
		}
		
		public function play():void {
			// null ad
			if (ad == null){
				trace("Ad is null");
				if (adDelegate != null) {
					adDelegate.adFailedToShow(ad.placementId);
				}
				return;
			}
			// ad exists but format is incorrect
			else if (ad != null) {
				if (ad.creative.creativeFormat != SACreativeFormat.video) {
					trace("ad is wrong creative");
					if (adDelegate != null) {
						adDelegate.adHasIncorrectPlacement(ad.placementId);
					}
					return;
				}
			}
			
			// play ad
			player = new SAVideoPlayer(frame, shouldShowSmallClickButton);
			addChildAt(player, 0);
			
			// start manager
			manager = new SAVASTManager(player);
			manager.delegate = this;
			manager.manageWithAd(ad.creative.details.data.vastAd);
			
			// add watermark
			if (ad.isFallback == false && ad.isHouse == false){
				var waterUrl:String = SuperAwesome.getInstance().getBaseURL() + "/images/watermark_1.png";
				watermark.load(new URLRequest(waterUrl));
				watermark.addEventListener(Event.ADDED, function(event:*=null): void {
					watermark.x = frame.x;
					watermark.y = frame.y;
					watermark.width = 67;
					watermark.height = 25;
				});
				addChildAt(watermark, 1);
			}
		}
		
		public function close():void {
			player.destroy();
			player = null;
			manager = null;
			
			if (adDelegate != null) {
				adDelegate.adWasClosed(ad.placementId);
			}
			
			this.parent.removeChild(this);
		}
		
		public function advanceToClick():void {
			// call delegate
			if (adDelegate != null) {
				adDelegate.adWasClicked(ad.placementId);
			}
			
			// send envents
			for (var i:int = 0; i < trackingArray.length; i++){
				SAEvents.sendEventToURL(trackingArray[i]);
			}
			
			// goto url
			trace("Going to " + destinationUrl);
			var request:URLRequest = new URLRequest(destinationUrl);
			navigateToURL(request, "_blank");
		}
		
		public function resizeToFrame(frame:Rectangle):void {
			
		}
		
		//
		// SAVASTManager Interface implementation
		
		public function didNotFindAds(): void {
			if (adDelegate != null){
				adDelegate.adFailedToShow(ad.placementId);
			}
		}
		
		public function didStartAd(): void {
			
			// send impressions
			SAEvents.sendEventToURL(ad.creative.viewableImpressionUrl);
			if (ad.creative.impresionUrl != null && ad.creative.impresionUrl.indexOf(SuperAwesome.getInstance().getBaseURL()) <= 0 ) {
				SAEvents.sendEventToURL(ad.creative.impresionUrl);
			}
			
			if (adDelegate != null){
				adDelegate.adWasShown(ad.placementId);
			}
		}
		
		public function didStartCreative(): void {
			if (videoDelegate != null) {
				videoDelegate.adStarted(ad.placementId);
			}
		}
		
		public function didReachFirstQuartileOfCreative(): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedFirstQuartile(ad.placementId);
			}
		}
		
		public function didReachMidpointOfCreative(): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedMidpoint(ad.placementId);
			}
		}
		
		public function didReachThirdQuartileOfCreative(): void {
			if (videoDelegate != null) {
				videoDelegate.videoReachedThirdQuartile(ad.placementId);
			}
		}
		
		public function didEndOfCreative():void {
			if (videoDelegate != null) {
				videoDelegate.videoEnded(ad.placementId);
			}
		}
		
		public function didHaveErrorForCreative(): void {
			
		}
		
		public function didEndAd(): void {
			if (videoDelegate != null) {
				videoDelegate.adEnded(ad.placementId);
			}
		}
		
		public function didEndAllAds(): void {
			if (videoDelegate != null) {
				videoDelegate.allAdsEnded(ad.placementId);
			} 
		}
		
		public function didGoToURL(url: String, clickTracking:Array): void {
			this.destinationUrl = url;
			this.trackingArray = clickTracking;
			this.advanceToClick();
		}
	}
}