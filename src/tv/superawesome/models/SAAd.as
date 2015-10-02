package tv.superawesome.models {
	// imports
	import tv.superawesome.models.SACreative;
	
	// class declaration
	public class SAAd {
		public var placementId: int;
		public var lineItemId: int;
		public var campaignId: int;
		public var isTest: Boolean;
		public var isFallback: Boolean;
		public var isFill: Boolean;
		public var creative: SACreative;
		
		public function SAAd(placementId: int, config: Object) {
			this.placementId = placementId;
			this.lineItemId = (config.line_item_id != null ? config.line_item_id : -1);
			this.campaignId = (config.campaign_id != null ? config.campaign_id : -1);
			this.isTest = (config.test != null ? config.test : true);
			this.isFallback = (config.is_fallback != null? config.is_fallback : true);
			this.isFill = (config.is_fill != null ? config.is_fill : false);
			
			if (config.creative != null) {
				this.creative = new SACreative(config.creative);
			}
		}
	}
}