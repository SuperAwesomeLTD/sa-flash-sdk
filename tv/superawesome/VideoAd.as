package tv.superawesome {
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	public class VideoAd extends Sprite {

		private var viewPort: Rectangle;
		private var vast: String;
		
		public function VideoAd(viewPort: Rectangle, appID: String, placementID: String) {
			this.viewPort = viewPort;
			ConfigLoader.getInstance().getVideoAd(appID, placementID, configLoaded);
		}

		private function configLoaded(config: Object) {
			vast = config.vast;
			loadPlayer();
		}

		private function loadPlayer() {
			var url: String = "VideoPlayer.swf";
			var urlReq: URLRequest = new URLRequest(url);
			var ldr: Loader = new Loader();
			ldr.load(urlReq);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoaded);
		}

		private function playerLoaded(e: Event): void {
			var mcExt: MovieClip = MovieClip(e.target.content);
			trace(mcExt.width + " " + mcExt.height);
			mcExt.x = viewPort.x;
			mcExt.y = viewPort.y;
			mcExt.width = viewPort.width;
			mcExt.height = viewPort.height;
			addChild(mcExt);
			mcExt.playVideoAd(vast);
		}
	}
}