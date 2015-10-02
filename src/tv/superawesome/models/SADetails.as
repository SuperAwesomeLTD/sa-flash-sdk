package tv.superawesome.models {
	public class SADetails {
		public var width: int;
		public var height: int;
		public var image: String;
		public var name: String;
		public var video: String;
		public var bitrate: int;
		public var duration: int;
		public var vast: String;
		
		public function SADetails(config: Object) {
			this.width = (config.width != null ? config.width : 0);
			this.height = (config.height != null ? config.height : 0);
			this.image = (config.image != null ? config.image : null);
			this.name = (config.name != null ? config.name : null);
			this.video = (config.video != null ? config.video : null);
			this.bitrate = (config.bitrate != null ? config.bitrate : 0);
			this.duration = (config.duration != null ? config.duration : 0);
			this.vast = (config.vast != null ? config.vast : null);
		}
	}
}