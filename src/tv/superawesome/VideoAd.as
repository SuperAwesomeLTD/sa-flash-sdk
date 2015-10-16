package tv.superawesome {
	// import
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import tv.superawesome.models.SAAd;
	import com.adobe.serialization.json.JSON;
	
	// class definition
	public class VideoAd extends Sprite {

		private var placementId: int;
		private var viewPort: Rectangle;
		private var ad: SAAd;
		
		private var loadFunc: Function = null;
		private var failFunc: Function = null;
		private var emptyFunc: Function = null;
		private var closeFunc: Function = null;
		
		public function VideoAd(viewPort: Rectangle, placementId: int) {
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
		
		public function play(): void {
			// load data
			var baseURL: String = SuperAwesome.getInstance().getBaseURL();
			var isTest: Boolean = SuperAwesome.getInstance().getTestMode();
			var crossDomainURL: String = baseURL + "/crossdomain.xml";
			trace(crossDomainURL);
			var URLString:String = baseURL + "/v2/ad/"+placementId+"?test="+isTest;
			
			Security.allowDomain("*");
			Security.allowDomain("s.ytimg.com");
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
				
				// continue with ad config
				ad = new SAAd(placementId, config);
				
				// load player
				loadPlayer();
			} 
			// error branch (maybe the server didn't send the right JSON)
			catch (e: SyntaxError) {
				var err: ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
				err.text = "Unable to load config from ad server";
				onError(err);
			}
		}

		private function loadPlayer(): void {
			var baseURL: String = SuperAwesome.getInstance().getBaseURL();
			var url: String = "VideoPlayer.swf";
			trace(url);
			
			var urlReq: URLRequest = new URLRequest(url);
			var ldr: Loader = new Loader();
			ldr.load(urlReq);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoaded);
		}

		private function playerLoaded(e: Event): void {
			trace(e.target.content);
			var mcExt: MovieClip = MovieClip(e.target.content);
			trace(mcExt.width + " " + mcExt.height);
			mcExt.x = viewPort.x;
			mcExt.y = viewPort.y;
			mcExt.width = viewPort.width;
			mcExt.height = viewPort.height;
			addChild(mcExt);
			mcExt.playVideoAd(this.ad.creative.details.video);
			
			// success
			sendLoadMessage();
		}
	}
}