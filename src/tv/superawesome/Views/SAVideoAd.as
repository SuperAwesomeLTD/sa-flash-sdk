// ActionScript file

package tv.superawesome.Views {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import tv.superawesome.Views.SAVideoAdProtocol;
	import tv.superawesome.Views.SAView;
	
	public class SAVideoAd extends SAView {
		private var background: Sprite;
		private var stream_ns: NetStream;
		private var video: Video;
		private var mc:MovieClip;
		public var videoDelegate: SAVideoAdProtocol;
		
		
		// constructors
		public function SAVideoAd(frame: Rectangle, placementId: int = NaN) {
			// call to super
			super(frame, placementId);
		}
		
		protected override function display(): void {	
			if (this.stage != null) delayedDisplay();
			else this.addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		protected function delayedDisplay(e:Event = null): void {
			// get background img
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = super.frame.x;
			background.y = super.frame.y;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			// resize video
			var newR: Rectangle = super.frame;
			
			if (super.maintainsAspectRatio == true) {
				newR = super.arrangeAdInFrame(super.frame);
				newR.x += super.frame.x;
				newR.y += super.frame.y;
			}
			
			// create connection
			var connection_nc: NetConnection = new NetConnection(); 
			connection_nc.connect(null); 
			stream_ns = new NetStream(connection_nc); 
			var client: Object = new Object(); 
			stream_ns.client = client; 
			stream_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			
			// create video
			video = new Video(); 
			video.attachNetStream(stream_ns); 
			video.x = newR.x;
			video.y = newR.y;
			video.width = newR.width;
			video.height = newR.height;
			
			// create movie click
			mc = new MovieClip();
			mc.addEventListener(MouseEvent.CLICK, onClick);
			mc.addChild(video);
			this.addChild(mc);
			
			// actually play the video
			stream_ns.play(ad.creative.details.video); 
			
			// call success
			success();
			
		}	
		
		private function onStatus(stats: NetStatusEvent): void {
			var code:String = stats.info.code;
			trace(code);
			switch (code) {
				case "NetStream.Play.Start":{
					trace("video started");
					if (videoDelegate != null) {
						videoDelegate.videoStarted(ad.placementId);
					}
					break;
				}
				case "NetStream.Play.Stop": {
					trace("video stopped");
					if (videoDelegate != null) {
						videoDelegate.videoEnded(ad.placementId);
					}
					break;
				}
				case "NetStream.Play.StreamNotFound": {
					trace("video error");
					error();
					break;		
				}
			}
		}
		
		private function onClick(event: MouseEvent): void {
			goToURL();
		}
	}
}
