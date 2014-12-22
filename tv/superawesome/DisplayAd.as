package tv.superawesome {

	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class DisplayAd extends Sprite {

		private var viewPort: Rectangle;
		private var linkURL: String;
		private var imgURL: String;
		private var cookie: String;
		private var imgLoader = new Loader();

		public function DisplayAd(viewPort: Rectangle, appID: String, placementID: String) {
			this.viewPort = viewPort;
			var asRequest: URLRequest = new URLRequest("https://ads.superawesome.tv/v1/unity/ad?app_id=" + appID + "&placement_id=" + placementID);
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, asLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(asRequest);
		}

		private function onError(e: ErrorEvent): void {
			dispatchEvent(e);
		}

		private function asLoaded(e: Event): void {
			try {
				var config: Object = JSON.parse(e.target.data);
				linkURL = config.placement_link;
				imgURL = config.placement_img;
				cookie = config.cookie;

				var imgURLRequest = new URLRequest(imgURL);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				var loaderContext: LoaderContext = new LoaderContext();
				loaderContext.checkPolicyFile = false;
				imgLoader.load(imgURLRequest, loaderContext);
			} catch (e: SyntaxError) {
				var err: ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
				err.text = "Unable to load config from ad server";
				onError(err);
			}
		}

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
		}

		private function reportClick(event: MouseEvent): void {
			var asRequest: URLRequest = new URLRequest("https://ads.superawesome.tv/v1/unity/link?placement_link=" + linkURL + "&cookie=" + cookie);
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, clickLoaded);
			loader.load(asRequest);
		}

		private function clickLoaded(e: Event): void {
			var config: Object = JSON.parse(e.target.data);
			var req: URLRequest = new URLRequest(config.link);
			navigateToURL(req, null);
		}
	}
}