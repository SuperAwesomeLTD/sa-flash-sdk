package tv.superawesome.sdk.Views {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;
	
	import tv.superawesome.libevents.SAEvents;
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.sdk.Models.SACreativeFormat;
	
//	import flash.utils.clearInterval;
//	import flash.utils.setInterval;

	public class SABannerAd extends Sprite implements SAViewInterface  {
		
		// private var
		private var ad:SAAd = null;
		private var frame:Rectangle;
		private var imgLoader: Loader = new Loader();
		private var watermark: Loader = new Loader();
		
		// public vars
		public var adDelegate:SAAdInterface = null;
		
		// constructor
		public function SABannerAd(frame: Rectangle) {
			// super();
			this.frame = frame;
			this.graphics.beginFill(0xf3f3f3);
			this.graphics.drawRect(frame.x, frame.y, frame.width, frame.height);
			this.graphics.endFill();
		}
		
		public function setAd(ad:SAAd): void {
			this.ad = ad;
		}
		
		public  function getAd():SAAd {
			return ad;
		}
		
		public function play():void {
			// handle errors
			if (ad == null){
				if (adDelegate != null) {
					adDelegate.adFailedToShow(ad.placementId);
				}
				return;
			} else {
				if (ad.creative.creativeFormat != SACreativeFormat.image) {
					if (adDelegate != null) {
						adDelegate.adFailedToShow(ad.placementId);
					}
					return;	
				}
			}
			
			// call to success
			if (adDelegate != null) {
				adDelegate.adWasShown(ad.placementId);
			}
			
			var newR: Rectangle = SAUtils.arrangeAdInNewFrame(
				frame, 
				new Rectangle(0, 0, ad.creative.details.width, ad.creative.details.height)
			);
			newR.x += frame.x;
			newR.y += frame.y;
			
			// add the banner iamge
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			imgLoader = new Loader();
			imgLoader.load(new URLRequest(ad.creative.details.data.imagePath), loaderContext);
			imgLoader.addEventListener(Event.ADDED, function(event:*=null): void {
				imgLoader.x = newR.x;
				imgLoader.y = newR.y;
				imgLoader.width = newR.width;
				imgLoader.height = newR.height;
				
			});
			imgLoader.addEventListener(MouseEvent.CLICK, function(event:*= null): void {
				advanceToClick();
			});
			addChildAt(imgLoader, 0);
			
			// add watermark
			if (ad.isFallback == false && ad.isHouse == false){
				var waterUrl:String = SuperAwesome.getInstance().getBaseURL() + "/images/watermark_67x25_small.png";
				watermark.load(new URLRequest(waterUrl));
				watermark.addEventListener(Event.ADDED, function(event:*=null): void {
					watermark.x = newR.x;
					watermark.y = newR.y;
					watermark.width = 67;
					watermark.height = 25;
				});
				addChildAt(watermark, 1);
			}
			
			// send impressions
			SAEvents.sendEventToURL(ad.creative.viewableImpressionUrl);
			if (ad.creative.impresionUrl != null && ad.creative.impresionUrl.indexOf(SuperAwesome.getInstance().getBaseURL()) <= 0 ) {
				SAEvents.sendEventToURL(ad.creative.impresionUrl);
			}
		}
		
		public function close():void {
			this.parent.removeChild(this);
			
			if (adDelegate != null) {
				adDelegate.adWasClosed(ad.placementId);
			}
		}
		
		public function advanceToClick():void {
			if (adDelegate != null) {
				adDelegate.adWasClicked(ad.placementId);
			}
			
			if (ad.creative.clickUrl.indexOf(SuperAwesome.getInstance().getBaseURL()) <= 0){
				SAEvents.sendEventToURL(ad.creative.trackingUrl);
			}
			
			// goto url
			trace("Going to " + ad.creative.clickUrl);
			var request:URLRequest = new URLRequest(ad.creative.clickUrl);
			navigateToURL(request, "_blank");
		}
		
		public function resizeToFrame(frame:Rectangle):void {
			
		}
		
		private function onError(event:* = null): void {
			if (adDelegate != null) {
				adDelegate.adFailedToShow(ad.placementId);
			}
		}
	}
}