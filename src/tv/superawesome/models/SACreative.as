package tv.superawesome.models {
	// import
	import tv.superawesome.models.SADetails;
	
	// class declaration
	public class SACreative {
		public var creativeId: int;
		public var name: String;
		public var format: String;
		public var clickURL: String;
		public var details: SADetails;
		
		public function SACreative(config: Object){
			
			this.creativeId = (config.id != null ? config.id : -1);
			this.name = (config.name != null ? config.name : null);
			this.format = (config.format != null ? config.format : null);
			this.clickURL = (config.click_url != null ? config.click_url : null);
				
			if (config.details != null) {
				details = new SADetails(config.details);
			}
		}
	}
}