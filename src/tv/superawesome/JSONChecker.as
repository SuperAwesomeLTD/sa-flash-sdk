// ActionScript file
package tv.superawesome {
	class JSONChecker {
		
		// function that checks to see if a JSON is valid from the POV of SuperAwesome ads
		public static function checkAdIsValid(ad: Object): Boolean {
			
			if (ad == null) return false;
			
			if (ad.line_item_id == null) return false;
			if (ad.campaign_id == null) return false;
//			if (ad.test == null) return false;			// optional
//			if (ad.is_fallback == null) return false; 	// optional
//			if (ad.is_fill == null) return false;		// optional
			
			if (ad.creative == null) return false;
			if (ad.creative.id == null) return false;
//			if (ad.creative.name == null) return false;	// optional
//			if (ad.creative.format == null) return false; 	// optional
//			if (ad.creative.click_url == null) return false;	// optional
			
			if (ad.creative.details == null) return false;
			if (ad.creative.details.image == null && ad.creative.details.video == null) return false;
			
			return true;
		}
	}
}