//
//  SAValidator.h
//  tv.superawesome.Data.Validator
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Validator {
	
	// imports for this class
	import tv.superawesome.sdk.AdParser.Models.SAAd;
	import tv.superawesome.sdk.AdParser.Models.SACreativeFormat;
	
	// @brief:
	// Important class that acts as validator for an Ad. Each time an ad is loaded
	// from the network, this function makes sure that
	// a) It's loaded metadata OK
	// b) based on specific types of ads, some fields are mandatory
	// If these conditions are not met, the ad is not valid and should not
	// be displayed
	public class SAValidator {
		
		// function that validates ad data
		public static function isAdDataValid(ad: SAAd): Boolean {
			
			// 0. if the ad itself is null
			if (ad == null) 
				return false;
			
			// 1. if Ad has no Creative, data is not valid
			if (ad.creative == null)
				return false;
			
			if (ad.creative != null) {
				// 2. if format is unknown, data is not valid
				if (ad.creative.creativeFormat == SACreativeFormat.invalid)
					return false;
				
				// 3. if creative has no details, data is not valid
				if (ad.creative.details == null)
					return false;
				
				if (ad.creative.details != null) {
					switch (ad.creative.creativeFormat) {
						case SACreativeFormat.image:{
							// 3.1. if Ad is image with link, but no image filed
							// could be found, data is not valid
							if (ad.creative.details.image == null)
								return false;
							break;
						}
						case SACreativeFormat.video:{
							// 3.2. if Ad is video and either the video or the vast
							// tags could not be found, data is not valid
							if (ad.creative.details.vast == null)
								return false;
							break;
						}
						case SACreativeFormat.rich:{
							// 3.3. if Ad is rich media and no url can be found,
							// then data is not valid
							if (ad.creative.details.url == null)
								return false;
							break;
						}
						case SACreativeFormat.tag:{
							// 3.4. if Ad is tag and no tag can be found,
							// then data is not valid
							if (ad.creative.details.tag == null)
								return false;
							break;
						}
						default:{
							break;
						}
					}
				}
			}
			
			return true;
		}
	}	
}