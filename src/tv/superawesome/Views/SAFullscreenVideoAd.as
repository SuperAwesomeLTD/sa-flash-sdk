// ActionScript file

package tv.superawesome.Views {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.MovieClip;
	
	import tv.superawesome.Views.SAVideoAdProtocol;
	import tv.superawesome.Views.SAView;
	
	public class SAFullscreenVideoAd extends SAView {
		// private vars
		private var bg: Sprite;
		private var stream_ns: NetStream;
		private var video: Video ;
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
			
			// 1. add placeholder background
			bg = new Sprite();
			bg.x = 0;
			bg.y = 0;
			stage.addChild(bg);
			
			// 2. add real bg
			var bdrm: Sprite = new Sprite();
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			bdrm.addChild(bmp2);
			bdrm.x = 0;
			bdrm.y = 0;
			bdrm.width = super.frame.width;
			bdrm.height = super.frame.height;
			bg.addChild(bdrm);
			
			// 3. calc scaling
			var newR: Rectangle = super.arrangeAdInFrame(super.frame);
			newR.x += super.frame.x;
			newR.y += super.frame.y;
			
			// 3. create connection
			var connection_nc: NetConnection = new NetConnection(); 
			connection_nc.connect(null); 
			stream_ns = new NetStream(connection_nc); 
			stream_ns.client = new Object(); 
			stream_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			
			// 4. create video
			video = new Video(); 
			video.attachNetStream(stream_ns); 
			video.x = newR.x;
			video.y = newR.y;
			video.width = newR.width;
			video.height = newR.height;
			var mc:MovieClip = new MovieClip();
			mc.addChild(video);
			mc.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				goToURL();
			});
			bg.addChild(mc);
			
			// 5. actually play the video
			stream_ns.play(ad.creative.details.video);
			
			// 6. the close button
			var spr: Sprite = new Sprite();
			[Embed(source = '../../../resources/close.png')] var CancelIconClass:Class;
			var bmp: Bitmap = new CancelIconClass();
			spr.addChild(bmp);
			spr.x = super.frame.width-35;
			spr.y = 5;
			spr.width = 30;
			spr.height = 30;
			bg.addChild(spr);
			spr.addEventListener(MouseEvent.CLICK, close);
		}
		
		private function close(event: MouseEvent): void {
			// stop this
			stream_ns.pause();
			video.clear();
			
			// call remove child
			stage.removeChild(bg);
			
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
			}
		}
	}
}