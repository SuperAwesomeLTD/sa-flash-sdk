package tv.superawesome.libvideo {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Loader;
	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.net.*;
	
	public class SAVideoPlayer extends Sprite {
		
		///////////////////////////////////////////////////////////////
		// Vars and construtor
		///////////////////////////////////////////////////////////////
		private var frame:Rectangle;
		
		public function SAVideoPlayer(frame: Rectangle) {
			this.frame = frame;
			setup();
		}
		
		///////////////////////////////////////////////////////////////
		// Setup
		///////////////////////////////////////////////////////////////
		
		private function setup(): void {
			setupPlayer();
			setupChrome();
			setupChecks();
		}
		
		private function setupChecks(): void {
			
		}
		
		private function setupPlayer(): void {
			
		}
		
		private function setupChrome(): void {
			
		}
		
		///////////////////////////////////////////////////////////////
		// Destroy
		///////////////////////////////////////////////////////////////
		public function destroy(): void  {
			destroyPlayer();
			destroyChrome();
		}
		
		private function destroyPlayer(): void {
			
		}
		
		private function destroyChrome(): void {
			
		}
		
		///////////////////////////////////////////////////////////////
		// Reset
		///////////////////////////////////////////////////////////////
		public function reset(): void  {
			destroy();
			setup();
		}
		
		public function updateToFrame(frame: Rectangle): void {
			
		}
		
		///////////////////////////////////////////////////////////////
		// Play functions
		///////////////////////////////////////////////////////////////
		
		public function playWithMediaURL(url: String): void {
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Object): void {
				trace("loaded");
			});
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(evt:SecurityErrorEvent): void {
				trace("security error");
				throw new Error(evt.text);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(evt:IOErrorEvent): void {
				trace("io error");
				throw new Error(evt.text);
			});
			loader.load(new URLRequest(url), loaderContext);
			loader.x = this.frame.x;
			loader.y = this.frame.y;
			// calc size
			addChild(loader);
		}
	}
}