package tv.superawesome.libvideo {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import tv.superawesome.libutils.SAUtils;
	
	public class SAVideoPlayer extends Sprite {
		
		///////////////////////////////////////////////////////////////
		// Vars and construtor
		///////////////////////////////////////////////////////////////
		private var frame:Rectangle;
		
		// net connection & video stuff
		private var nc:NetConnection = null; 
		private var ns:NetStream = null; 
		private var video:Video = null;
		private var client: Object = null;
		
		// background
		[Embed(source='../../../resources/mark.png')] private var markClass:Class;
		private var mark:Bitmap = null;
		
		// text labels
		private var chronographerBg: Sprite = null;
		private var chronographer: TextField = null;
		private var clickerTxt: TextField = null;
		private var clickerBtn: Sprite = null;
		
		// other video variables
		private var duration:int = 0;
		private var videoInterval:* = null;
		
		// bool vars for each step
		private var isReadyHandled:Boolean = false;
		private var isStartHandled:Boolean = false;
		private var isFirstQuartileHandled:Boolean = false;
		private var isMidpointHandled:Boolean = false;
		private var isThirdQuartileHandled:Boolean = false;
		private var isCompleteHandled:Boolean = false;
		
		// listener
		public var delegate:SAVideoPlayerInterface = null;
		public var shouldShowSmallClickButton:Boolean = false;
		
		public function SAVideoPlayer(frame: Rectangle, shouldShowSmallClickButton:Boolean) {
			this.frame = frame;
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(frame.x, frame.y, frame.width, frame.height);
			this.graphics.endFill();
			this.shouldShowSmallClickButton = shouldShowSmallClickButton;
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
			isReadyHandled = false;
			isStartHandled = false;
			isFirstQuartileHandled = false;
			isMidpointHandled = false;
			isThirdQuartileHandled = false;
			isCompleteHandled = false;
		}
		
		private function setupPlayer(): void {
			video = new Video();
			video.x = frame.x;
			video.y = frame.y;
			video.width = frame.width;
			video.height = frame.height;
			addChildAt(video, 0);
		}
		
		private function setupChrome(): void {
			// add mark
			mark = new markClass();
			mark.x = frame.x;
			mark.y = frame.y + frame.height - 24;
			mark.width = frame.width;
			mark.height = 24;
			addChildAt(mark, 1);
			
			// add chronographer
			chronographerBg = new Sprite();
			chronographerBg.graphics.beginFill( 0x030303, 0.35 );
			chronographerBg.graphics.drawRoundRect(frame.x + 10, frame.y + frame.height - 27, 50, 21, 10);
			chronographerBg.graphics.endFill();			
			addChildAt(chronographerBg, 2);
			
			// add chronotext
			var format:TextFormat = new TextFormat();
			format.color = 0xffffff;
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.size = 10;
			
			chronographer = new TextField();
			chronographer.defaultTextFormat = format;
			chronographer.text = "Ad: " + this.duration;
			chronographer.x = frame.x + 10;
			chronographer.y = frame.y + frame.height - 24;
			chronographer.width = 50;
			chronographer.height = 15;
			addChildAt(chronographer, 3);
			
			if (shouldShowSmallClickButton == true) {
				var clickerX: Number = frame.x + 65;
				var clickerY: Number = frame.y + frame.height - 24;
				var clickerW: Number = frame.width - 65;
				var clickerH: Number = 15;
				
				// add clicker text
				var clickerFormat: TextFormat = new TextFormat();
				clickerFormat.color = 0xffffff;
				clickerFormat.font = "Arial";
				clickerFormat.size = 10;
				
				clickerTxt = new TextField();
				clickerTxt.defaultTextFormat = clickerFormat;
				clickerTxt.text = "Find out more »";
				clickerTxt.x = clickerX;
				clickerTxt.y = clickerY;
				clickerTxt.width = clickerW;
				clickerTxt.height = clickerH;
				addChildAt(clickerTxt, 3);
				
				// add clicker button
				clickerBtn = new Sprite();
				clickerBtn.graphics.beginFill( 0xFFFFFF, 0 );
				clickerBtn.graphics.drawRect( clickerX, clickerY, clickerW, clickerH );
				clickerBtn.graphics.endFill();
				clickerBtn.buttonMode = true;
				clickerBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
				addChildAt(clickerBtn, 4);
			} else {
				clickerBtn = new Sprite();
				clickerBtn.graphics.beginFill( 0xFFFFFF, 0 );
				clickerBtn.graphics.drawRect( frame.x, frame.y, frame.width, frame.height );
				clickerBtn.graphics.endFill();
				clickerBtn.buttonMode = true;
				clickerBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
				addChildAt(clickerBtn, 4);	
			}
		}
		
		///////////////////////////////////////////////////////////////
		// Destroy
		///////////////////////////////////////////////////////////////
		public function destroy(): void  {
			destroyPlayer();
			destroyChrome();
		}
		
		private function destroyPlayer(): void {
			if (videoInterval != null) {
				clearInterval(videoInterval);
				videoInterval = null;
			}
			if (ns != null) {
			 	// ns.dispose();
				ns.close()
				ns = null;
			}
			if (client != null) {
				client.onMetaData = null;
				client = null;
			}
			if (nc != null) {
				nc.close();
			}
			if (video != null) {
				video.parent.removeChild(video);
				video = null;
			}
			if (delegate != null) {
				delegate = null;
			}
		}
		
		private function destroyChrome(): void {
			if (mark != null) {
				mark.parent.removeChild(mark);
				mark = null;
			}
			if (chronographerBg != null) {
				chronographerBg.parent.removeChild(chronographerBg);
				chronographerBg = null;
			}
			if (chronographer != null) {
				chronographer.parent.removeChild(chronographer);
				chronographer = null;
			}
			if (clickerBtn != null) {
				clickerBtn.parent.removeChild(clickerBtn);
				clickerBtn = null;
			}
			if (clickerTxt != null) {
				clickerTxt.parent.removeChild(clickerTxt);
				clickerTxt = null;
			}
		}
		
		///////////////////////////////////////////////////////////////
		// Reset
		///////////////////////////////////////////////////////////////
		public function reset(): void  {
			destroy();
			setup();
		}
		
		public function updateToFrame(frame: Rectangle): void {
			if (video != null) {
				video.x = frame.x;
				video.y = frame.y;
				video.width = frame.width;
				video.height = frame.height;
			}
		}
		
		///////////////////////////////////////////////////////////////
		// Play functions
		///////////////////////////////////////////////////////////////
		
		public function playWithMediaURL(url: String): void {
			// setup net connection
			nc = new NetConnection();
			nc.connect(null);	
			
			// create client
			client = new Object();
			client.onMetaData = onMetaData;
			
			// setup netstream
			ns = new NetStream(nc); 
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEvent); 
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
			ns.client = client;
			ns.play(url);
			
			// attach video stream to rendering surface
			video.attachNetStream(ns); 
		}
		
		public function onMetaData(metadata:Object):void {
			// set duration
			this.duration = int(metadata.duration);
			this.chronographer.text = "Ad: " + this.duration;
			
			// remove client
			client.onMetaData = null;
			client = null;
		}
		
		public function onAsyncErrorEvent(event:AsyncErrorEvent): void {
			if (delegate != null) {
				delegate.didPlayWithError();
			}
		}
		
		public function onNetStatusEvent(event:NetStatusEvent): void {
			var code:* = event.info.code;
			
			switch(code){
				case "NetStream.Play.Start":{
					
					// resize video
					var rect1:Rectangle = new Rectangle(0, 0, this.frame.width, this.frame.height);
					var rect2:Rectangle = new Rectangle(0, 0, this.video.videoWidth, this.video.videoHeight);
					var final:Rectangle = SAUtils.arrangeAdInNewFrame(rect1, rect2);
					this.video.x = this.frame.x + final.x;
					this.video.y = this.frame.y + final.y;
					this.video.width = final.width;
					this.video.height = final.height;
					
					// start counting
					this.videoInterval = setInterval(videoUpdate, 500);
					
					// call events
					if (delegate != null && !isReadyHandled){
						isReadyHandled = true;
						delegate.didFindPlayerReady();
					}
					
					break;
				}
				case "NetStream.Play.Stop":{
					// call events
					if (delegate != null) {
						delegate.didReachEnd();
					}
					
					// destroy all
					destroy();
					
					break;
				}
			}
		}
		
		public function videoUpdate(): void {
			// get current & remaining time
			var current: int = int(ns.time);
			var remaining: int = int(duration - current);
			
			// start calling methods
			if (current >= 1 && delegate != null && !isStartHandled){
				isStartHandled = true;
				delegate.didStartPlayer();
			}
			if (current >= duration / 4 && delegate != null && !isFirstQuartileHandled){
				isFirstQuartileHandled = true;
				delegate.didReachFirstQuartile();
			}
			if (current >= duration / 2 && delegate != null && !isMidpointHandled){
				isMidpointHandled = true;
				delegate.didReachMidpoint();
			}
			
			if (current >= 3 * duration / 4 && delegate != null && !isThirdQuartileHandled){
				isThirdQuartileHandled = true;
				delegate.didReachThirdQuartile();
			}
			
			// set timer
			chronographer.text = "Ad: " + remaining;
		}
		
		///////////////////////////////////////////////////////////////
		// Click functions
		///////////////////////////////////////////////////////////////
		
		public function onBtnClick(event:MouseEvent): void {
			if (delegate != null) {
				delegate.didGoToURL();
			}
		}
	}
}