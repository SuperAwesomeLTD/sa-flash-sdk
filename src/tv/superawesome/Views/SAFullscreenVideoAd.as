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
	
	public class SAFullscreenVideoAd extends SAView {
		// private vars
		private var background: Sprite;
		private var close: Sprite;
		private var stream_ns: NetStream;
		private var video: Video;
		private var mc:MovieClip;
		public var videoDelegate: SAVideoAdProtocol;
		
		public function SAFullscreenVideoAd(placementId: int = NaN) {
			super(new Rectangle(0,0,0,0), placementId);
		}
		
		protected override function display(): void {
			if (stage) intestitialDisplay();
			else addEventListener(Event.ADDED_TO_STAGE, intestitialDisplay);
		}
		
		private function intestitialDisplay(e:Event = null): void  {
			super.frame = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// load statical resources
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = 0;
			background.y = 0;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			// calc scaling
			var tW: Number = super.frame.width * 0.85;
			var tH: Number = super.frame.height * 0.85;
			var tX: Number = ( super.frame.width - tW ) / 2;
			var tY: Number = ( super.frame.height - tH) / 2;
			var newR: Rectangle = super.arrangeAdInFrame(new Rectangle(tX, tY, tW, tH));
			newR.x += tX;
			newR.y += tY;
			
			// create connection
			var connection_nc: NetConnection = new NetConnection(); 
			connection_nc.connect(null); 
			stream_ns = new NetStream(connection_nc); 
			stream_ns.client = new Object(); 
			stream_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			
			// create video
			video = new Video(); 
			video.attachNetStream(stream_ns); 
			video.x = newR.x;
			video.y = newR.y;
			video.width = newR.width;
			video.height = newR.height;
			
			// create movie clip
			mc = new MovieClip();
			mc.addEventListener(MouseEvent.CLICK, onClick);
			mc.addChild(video);
			this.addChild(mc);
			
			// 5. actually play the video
			stream_ns.play(ad.creative.details.video);
			
			// 6. the close button
			[Embed(source = '../../../resources/close.png')] var CancelIconClass:Class;
			var bmp: Bitmap = new CancelIconClass();
			
			close = new Sprite();
			close.addChild(bmp);
			close.x = super.frame.width-35;
			close.y = 5;
			close.width = 30;
			close.height = 30;
			close.addEventListener(MouseEvent.CLICK, closeAction);
			this.addChild(close);
			
			// success
			success();
		}
		
		private function closeAction(event: MouseEvent): void {
			// stop this
			stream_ns.pause();
			video.clear();
			
			// call remove child
			this.parent.removeChild(this);
			
			// call delegate
			if (super.delegate != null) {
				super.delegate.adWasClosed(ad.placementId);
			}
		}
		
		public function onStatus(stats: NetStatusEvent): void {
			trace(stats.info.code);
			var code:String = stats.info.code;
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