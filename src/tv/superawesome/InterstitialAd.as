package tv.superawesome {
	
	// imports
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import tv.superawesome.models.SAAd;
	import com.adobe.serialization.json.JSON;
	
	public class InterstitialAd extends Sprite {
		
		// private variables
		private var placementId: int;
		private var viewPort: Rectangle;	// for interstitial it will as big as the screen
		private var ad: SAAd;
		private var imgLoader: Loader = new Loader();
		private var bg: Sprite; 
		
		private var loadFunc: Function = null;
		private var failFunc: Function = null;
		private var emptyFunc: Function = null;
		private var closeFunc: Function = null;
		
		// constructor
		public function InterstitialAd(placementId: int) {
			// get variables
			this.placementId = placementId;
		}
		
		// two functions used to display what happens on load and on fail
		public function onAdLoad(f: Function): void {
			this.loadFunc = f;
		}
		
		public function onAdFail(f: Function): void {
			this.failFunc = f;
		}
		
		public function onAdEmpty(f: Function): void {
			this.emptyFunc = f;
		}
		
		public function onAdClose(f: Function): void {
			this.closeFunc = f;
		}
		
		private function sendFailMessage(): void {
			if (this.failFunc != null){
				this.failFunc();
			}
		}
		
		private function sendLoadMessage(): void {
			if (this.loadFunc != null) {
				this.loadFunc();
			}
		}
		
		private function sendEmptyMessage(): void {
			if (this.emptyFunc != null) {
				this.emptyFunc();
			}
		}
		
		private function sendCloseMessage(): void {
			if (this.closeFunc != null) {
				this.closeFunc();
			}
		}
		
		//////////////////////////////////////////////////
		// public play function
		public function play(): void {
			// only when this is added to stage
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void  {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// load data
			var baseURL: String = SuperAwesome.getInstance().getBaseURL();
			var isTest: Boolean = SuperAwesome.getInstance().getTestMode();
			var crossDomainURL: String = baseURL + "/crossdomain.xml";
			trace(crossDomainURL);
			var URLString: String = baseURL + "/v2/ad/"+placementId+"?test=" + isTest;
			
			Security.allowDomain("*");
			Security.loadPolicyFile(crossDomainURL);
			
			trace(URLString);
			
			var asRequest: URLRequest = new URLRequest(URLString);
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSuccess);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(asRequest);
		}
		
		private function onError(e: ErrorEvent): void {
			dispatchEvent(e);
			sendFailMessage();
		}

		private function onSuccess(e: Event): void {
			// try - success branch
			try {
				// parse the new ad
				var config: Object = com.adobe.serialization.json.JSON.decode(e.target.data);
//				var config: Object = JSON.parse(e.target.data);
				var isValid: Boolean = JSONChecker.checkAdIsValid(config);
				
				if (!isValid) {
					sendEmptyMessage();
					return;
				}
				
				// continue with ad thing
				ad = new SAAd(placementId, config);
				
				// laod the imaga
				var loaderContext: LoaderContext = new LoaderContext();
				loaderContext.checkPolicyFile = false;
				
				var imgURLRequest:URLRequest = new URLRequest(ad.creative.details.image);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imgLoader.load(imgURLRequest, loaderContext);
			} 
			// error branch (maybe the server didn't send the right JSON)
			catch (e: SyntaxError) {
				var err: ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
				err.text = "Unable to load config from ad server";
				onError(err);
			}
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// 1. background
			bg = new Sprite();
			bg.graphics.beginFill(0xf3f3f3);
			bg.graphics.drawRect(0, 0, viewPort.width, viewPort.height);
			bg.graphics.endFill();
			bg.x = 0;
			bg.y = 0;
			stage.addChild(bg);
			
			// get ad width & height
			var W: int = this.ad.creative.details.width;
			var H: int = this.ad.creative.details.height;
				
			// taller
			if (H > W) {
				if (H > viewPort.height) {
					H = viewPort.height * 0.9;
					W = W * 0.9;
				}
			}
			// wider
			else {
				if (W > viewPort.width) {
					W = viewPort.width * 0.9;
					H = H * 0.9;
				}
			}
			
			var X: int = (viewPort.width - W) / 2;
			var Y: int = (viewPort.height - H) / 2;
			
			// 2. banner
			var loader = e.target;
			var innerImage = addChild(new Sprite());
			innerImage.buttonMode = true;
			imgLoader.x = X;
			imgLoader.y = Y;
			imgLoader.width = W;
			imgLoader.height = H;
			bg.addChild(imgLoader);
			imgLoader.addEventListener(MouseEvent.CLICK, reportClick);
			
			var positionX:int = viewPort.width-40;
			var positionY:int = 0;
			var matrix:Matrix = new Matrix();
			
			matrix.tx = positionX;
			matrix.ty = positionY;
			
			var spr: Sprite = new Sprite();
			var bmp: Bitmap = new Resources.CancelIconClass();
			spr.graphics.beginBitmapFill(bmp.bitmapData, matrix);
			spr.graphics.drawRect(viewPort.width-40, 0, 40, 40);
			spr.graphics.endFill();
			spr.x = 0;
			spr.y = 0;
			bg.addChild(spr);
			spr.addEventListener(MouseEvent.CLICK, close);
			
			// call success
			sendLoadMessage();
		}
		
		// what happens when a click is loaded
		private function reportClick(event: MouseEvent): void {
			var clickURL: URLRequest = new URLRequest(this.ad.creative.clickURL);
			navigateToURL(clickURL, "_blank");
		}
		
		private function close(event: MouseEvent): void {
			stage.removeChild(bg);
			sendCloseMessage();
		}
	}
}