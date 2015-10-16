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
	
	public class SABannerAd extends SAView {
		// the loader
		private var imgLoader: Loader = new Loader();
		private var bg: Sprite;
		
		public function SABannerAd(frame: Rectangle, placementId: int = NaN) {
			super(frame, placementId);
		}
		
		protected override function display(): void {
			// laod the imaga
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
			// 1. background
			bg = new Sprite();
			bg.x = 0;
			bg.y = 0;
			stage.addChild(bg);
			
			// 2. add real bg
			var bdrm: Sprite = new Sprite();
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			bdrm.addChild(bmp2);
			bdrm.x = super.frame.x;
			bdrm.y = super.frame.y;
			bdrm.width = super.frame.width;
			bdrm.height = super.frame.height;
			bg.addChild(bdrm);
			
			// 2. calc scaling
			var newR: Rectangle = super.arrangeAdInFrame(super.frame);
			newR.x += super.frame.x;
			newR.y += super.frame.y;
			
			// 3. position the image
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			
			// add the child
			bg.addChild(imgLoader);
		}
	}
}