// ActionScript file

package tv.superawesome.Views {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import tv.superawesome.Views.SAView;
	
	public class SAInterstitialAd extends SAView{
		// private vars
		private var imgLoader: Loader = new Loader();
		private var bg: Sprite;
		
		public function SAInterstitialAd(placementId: int = NaN) {
			super(new Rectangle(0,0,0,0), placementId);
		}
		
		protected override function display(): void {
			if (stage) intestitialDisplay();
			else addEventListener(Event.ADDED_TO_STAGE, intestitialDisplay);
		}
		
		private function intestitialDisplay(e:Event = null): void  {
			// setup the frame
			super.frame = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// send the request
			var imgURLRequest: URLRequest = new URLRequest(super.ad.creative.details.image);
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			imgLoader.load(imgURLRequest, loaderContext);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				goToURL();
			});
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// 1. add placeholder background
			bg = new Sprite();
			bg.x = 0;
			bg.y = 0;
			stage.addChild(bg);
			
			// 2. add real bg
			var bdrm: Sprite = new Sprite();
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			bdrm.addChild(bmp2);
			bdrm.x = 0;
			bdrm.y = 0;
			bdrm.width = super.frame.width;
			bdrm.height = super.frame.height;
			bg.addChild(bdrm);
			
			// 3. calc scaling
			var newR: Rectangle = super.arrangeAdInFrame(super.frame);
			newR.x += super.frame.x;
			newR.y += super.frame.y;
		
			// 4. banner
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			bg.addChild(imgLoader);
			
			var spr: Sprite = new Sprite();
			[Embed(source = '../../../resources/close.png')] var CancelIconClass:Class;
			var bmp: Bitmap = new CancelIconClass();
			spr.addChild(bmp);
			spr.x = super.frame.width-35;
			spr.y = 5;
			spr.width = 30;
			spr.height = 30;
			bg.addChild(spr);
			spr.addEventListener(MouseEvent.CLICK, close);
		}
		
		private function close(event: MouseEvent): void {
			// call remove child
			stage.removeChild(bg);
			
			// call delegate
			if (super.delegate != null) {
				super.delegate.adWasClosed(ad.placementId);
			}
		}
	}
}