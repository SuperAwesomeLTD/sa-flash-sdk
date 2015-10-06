package tv.superawesome{

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import tv.superawesome.models.SAAd;

	public class BannerAd extends Sprite {

		private var placementId: int;
		private var viewPort: Rectangle;
		private var ad: SAAd;
		private var imgLoader: Loader = new Loader();
		
		private var loadFunc: Function = null;
		private var failFunc: Function = null;
		private var closeFunc: Function = null;
		private var emptyFunc: Function = null;
		
		public function BannerAd(viewPort: Rectangle, placementId: int) {
			// update local vars
			this.placementId = placementId;
			this.viewPort = viewPort;
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
		
		/////////////////////////////////////////////////
		// From here on - play the ad
		public function play(): void{
			// load data
			var baseURL: String = SuperAwesome.getInstance().getBaseURL();
			var isTest: Boolean = SuperAwesome.getInstance().getTestMode();
			var crossDomainURL: String = baseURL + "/crossdomain.xml";
			var URLString: String = baseURL + "/v2/ad/"+placementId+"?test="+isTest;
			
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
				var config: Object = JSON.parse(e.target.data);
				var isValid:Boolean = JSONChecker.checkAdIsValid(config);
				
				if (!isValid) {
					sendEmptyMessage();
					return;
				}
				
				// go forward, this is valid
				ad = new SAAd(placementId, config);
				
				// laod the imaga
				var imgURLRequest: URLRequest = new URLRequest(ad.creative.details.image);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				var loaderContext: LoaderContext = new LoaderContext();
				loaderContext.checkPolicyFile = false;
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
			var loader = e.target;
			var innerImage = addChild(new Sprite());
			innerImage.buttonMode = true;
			innerImage.y = viewPort.x;
			innerImage.x = viewPort.y;
			imgLoader.width = viewPort.width;
			imgLoader.height = viewPort.height;
			innerImage.addChild(imgLoader);
			imgLoader.addEventListener(MouseEvent.CLICK, reportClick);
			
			// success
			sendLoadMessage();
		}

		// what happens when a click is loaded
		private function reportClick(event: MouseEvent): void {
			var clickURL: URLRequest = new URLRequest(this.ad.creative.clickURL);
			navigateToURL(clickURL, "_blank");
		}
	}
}