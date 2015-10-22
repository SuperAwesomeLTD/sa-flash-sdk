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
	
	import tv.superawesome.Views.SAView;
	
	public class SAInterstitialAd extends SAView{
		// private vars
		private var imgLoader: Loader = new Loader();
		private var background: Sprite;
		private var close: Sprite;
		
		public function SAInterstitialAd(placementId: int = NaN) {
			super(new Rectangle(0,0,0,0), placementId);
		}
		
		protected override function display(): void {
			if (stage) delayedDisplay();
			else addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void  {
			// setup the frame
			super.frame = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// load external resources
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			[Embed(source = '../../../resources/close.png')] var CancelIconClass:Class;
			var bmp: Bitmap = new CancelIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = 0;
			background.y = 0;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			close = new Sprite();
			close.addChild(bmp);
			close.x = super.frame.width-35;
			close.y = 5;
			close.width = 30;
			close.height = 30;
			close.addEventListener(MouseEvent.CLICK, closeAction);
			this.addChild(close);
			
			// send the request
			trace("Attempting to load " + super.ad.creative.details.image);
			var imgURLRequest: URLRequest = new URLRequest(super.ad.creative.details.image);
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			imgLoader.load(imgURLRequest, loaderContext);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			imgLoader.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// calc scaling
			var tW: Number = super.frame.width * 0.85;
			var tH: Number = super.frame.height * 0.85;
			var tX: Number = ( super.frame.width - tW ) / 2;
			var tY: Number = ( super.frame.height - tH) / 2;
			var newR: Rectangle = super.arrangeAdInFrame(new Rectangle(tX, tY, tW, tH));
			newR.x += tX;
			newR.y += tY;
			
			// banner
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			this.addChild(imgLoader);
			
			// call to success
			success();
		}
		
		private function onError(e: ErrorEvent): void {
			dispatchEvent(e);
			error();
		}
		
		private function closeAction(event: MouseEvent): void {
			// call remove child
			this.parent.removeChild(this);
			
			// call delegate
			if (super.delegate != null) {
				super.delegate.adWasClosed(ad.placementId);
			}
		}
		
		private function onClick(event: MouseEvent): void {
			goToURL();
		}
	}
}