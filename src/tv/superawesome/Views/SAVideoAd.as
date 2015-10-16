// ActionScript file

package tv.superawesome.Views {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import tv.superawesome.Views.SAVideoAdProtocol;
	import tv.superawesome.Views.SAView;
	
	public class SAVideoAd extends SAView {
		private var bg: Sprite;
		public var videoDelegate: SAVideoAdProtocol;
		
		// constructors
		public function SAVideoAd(frame: Rectangle, placementId: int = NaN) {
			super(frame, placementId);
		}
		
		protected override function display(): void {
			// 1. background
			bg = new Sprite();
			bg.x = 0;
			bg.y = 0;
			stage.addChild(bg);
			
			// 2. add real bg
			var bdrm: Sprite = new Sprite();
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			bdrm.addChild(bmp2);
			bdrm.x = super.frame.x;
			bdrm.y = super.frame.y;
			bdrm.width = super.frame.width;
			bdrm.height = super.frame.height;
			bg.addChild(bdrm);
			
			// 2. calc scaling
			var newR: Rectangle = super.arrangeAdInFrame(super.frame);
			newR.x += super.frame.x;
			newR.y += super.frame.y;
			
			// 3. create connection
			var connection_nc: NetConnection = new NetConnection(); 
			connection_nc.connect(null); 
			var stream_ns: NetStream = new NetStream(connection_nc); 
			var client: Object = new Object(); 
			stream_ns.client = client; 
			stream_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus); 
			
			// 4. create video
			var video: Video = new Video(); 
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
		}
		
		public function onStatus(stats: NetStatusEvent): void {
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
