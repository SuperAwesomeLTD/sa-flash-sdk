// ActionScript file

package tv.superawesome.Views {
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import tv.superawesome.Data.Models.SACreativeFormat;
	import tv.superawesome.Views.SAView;
	
	public class SABannerAd extends SAView {
		// the loader
		private var imgLoader: Loader = new Loader();
		private var background: Sprite;
		
		public function SABannerAd(frame: Rectangle) {
			super(frame);
		}
		
		public override function play(): void {	
			if (this.stage != null) delayedDisplay();
			else this.addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void {
			
			// do a check for invalid format
			if (ad.creative.format != SACreativeFormat.image) {
				if (super.delegate != null) {
					super.delegate.adIsNotCorrectFormat(ad.placementId);
				}
				return;
			}
			
			// create background and static elements
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = super.frame.x;
			background.y = super.frame.y;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			// laod the image async
			var imgURLRequest: URLRequest = new URLRequest(super.ad.creative.details.image);
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			imgLoader.load(imgURLRequest, loaderContext);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			imgLoader.addEventListener(MouseEvent.CLICK, goToURL);
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// calc scaling
			var newR: Rectangle = super.frame;
			
			if (super.maintainsAspectRatio == true) {
				newR = super.arrangeAdInFrame(super.frame);
				newR.x += super.frame.x;
				newR.y += super.frame.y;
			}
			
			// position the image
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			
			// add the child
			this.addChild(imgLoader);
			
			// remove listener
			e.target.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			// call to success
			success();
		}
		
		private function onError(e: ErrorEvent): void {
			dispatchEvent(e);
			error();
		}
	}
}