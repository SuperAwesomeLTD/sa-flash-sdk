package tv.superawesome {
	// import
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.net.*;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.system.Security;
	import tv.superawesome.models.*;
	
	// class definition
	public class VideoAd extends Sprite {

		private var placementId: int;
		private var viewPort: Rectangle;
		private var ad: SAAd;
		
		public function VideoAd(viewPort: Rectangle, placementId: int) {
			// update local vars
			this.placementId = placementId;
			this.viewPort = viewPort;
		}
		
		public function play(): void {
			// load data
			var baseURL: String = SuperAwesome.getInstance().getBaseURL();
			var isTest: Boolean = SuperAwesome.getInstance().getTestMode();
			var crossDomainURL: String = baseURL + "crossdomain.xml";
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
		}

		private function onSuccess(e: Event): void {
			// try - success branch
			try {
				// parse the new ad
				var config: Object = JSON.parse(e.target.data);
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
			mcExt.playVideoAd(this.ad.creative.details.vast);
		}
	}
}