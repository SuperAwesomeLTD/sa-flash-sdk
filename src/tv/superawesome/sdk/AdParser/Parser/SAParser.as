//
//  SAParser.h
//  tv.superawesome.Data.Parser
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Parser {
	
	// imports used by this class
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.AdParser.Models.SAAd;
	import tv.superawesome.sdk.AdParser.Models.SACreative;
	import tv.superawesome.sdk.AdParser.Models.SACreativeFormat;
	import tv.superawesome.sdk.AdParser.Models.SADetails;

	// this class has three parsing functions in it
	public class SAParser {
		
		// function that performs the basic integritiy check on the just-received ad
		private static function performIntegrityCheck(dict: Object): Boolean {
			
			// 1. check if dict is empty
			if (dict != null && !SAUtils.isEmptyObject(dict)) {
				// 2. check if dict object has a "creative" sub-object...
				var creativeObj: Object = dict.creative;
				
				// ...and it's a valid one
				if (creativeObj != null && !SAUtils.isEmptyObject(creativeObj)) {
					
					// 3. check if creativeObj object has a "details" sub-object...
					var detailsObj: Object = creativeObj.details;
					
					// ...and it's a valid one
					if (detailsObj != null && !SAUtils.isEmptyObject(detailsObj)) {
						return true;
					} 
					return false;
				} 
				return false;
			}
			return false;
		}
		
		private static function parseAd(dict: Object) : SAAd {
			var ad: SAAd = new SAAd();
			
			ad.error = (dict.error != null ? dict.error : -1);
			ad.lineItemId = (dict.line_item_id != null ? dict.line_item_id : -1);
			ad.campaignId = (dict.campaign_id != null ? dict.campaign_id : -1);
			ad.test = (dict.test != null ? dict.test : true);
			ad.isFallback = (dict.is_fallback != null ? dict.is_fallback : false);
			ad.isFill = (dict.is_fill != null ? dict.is_fill : false);
			
			return ad;
		}
		
		private static function parseCreative(cdict: Object): SACreative {
			var creative: SACreative = new SACreative();
			
			// do the parsing
			creative.id = (cdict.id != null ? cdict.id : -1);
			creative.name = (cdict.name != null ? cdict.name : null);
			creative.cpm = (cdict.cpm != null ? cdict.cpm : 0);
			creative.impresionUrl = (cdict.impression_url != null ? cdict.impression_url : null);
			creative.clickUrl = (cdict.click_url != null ? cdict.click_url : null);
			creative.approved = (cdict.approved != null ? cdict.approved : false);
			creative.format = (cdict.format != null ? cdict.format : null);
			
			return creative;
		}
		
		private static function parseDetails(ddict: Object): SADetails {
			var details: SADetails = new SADetails();
			
			details.width = (ddict.width != null ? ddict.width : 0);
			details.height = (ddict.height != null ? ddict.height : 0);
			details.image = (ddict.image != null ? ddict.image : null);
			details.value = (ddict.value != null ? ddict.value: -1);
			details.name = (ddict.name != null ? ddict.name : null);
			details.video = (ddict.video != null ? ddict.video : null);
			details.bitrate = (ddict.bitrate != null ? ddict.bitrate : 0);
			details.duration = (ddict.duration != null ? ddict.duration : 0);
			details.vast = (ddict.vast != null ? ddict.vast : null);
			details.tag = (ddict.tag != null ? ddict.tag : null);
			details.zipFile = (ddict.zip_file != null ? ddict.zip_file : null);
			details.url = (ddict.url != null ? ddict.url : null);
			details.placementFormat = (ddict.placement_format != null ? ddict.placement_format : null);
			
			return details;
		}		
		
		// @brief:
		// The SAParser class acts contains one static function that parses a
		// network-received dictionary into an Ad
		// @param - adDict: A NSDictionary parser by ObjC from a JSON
		// @param - placementId - the placement id of the ad that's been requested
		// @param - parse - a callback that actually returns the ad
		public static function parseDictionary(adDict: Object, placementId: int, parse: Function): void {
			
			// perform an integrity check
			if (!SAParser.performIntegrityCheck(adDict)){
				parse(null);
				return;
			}
			
			// if all is OK so far, extract all dictionaries
			var adict:Object = adDict;
			var cdict:Object = adict.creative;
			var ddict:Object = cdict.details;
			
			var ad: SAAd = SAParser.parseAd(adict);
			ad.placementId = placementId;
			ad.creative = SAParser.parseCreative(cdict);
			ad.creative.details = SAParser.parseDetails(ddict);
			
			// perform the next steps of the parsing
			ad.creative.creativeFormat = SACreativeFormat.invalid;
			// case "image_with_link"
			if (ad.creative.format == "image_with_link") ad.creative.creativeFormat = SACreativeFormat.image;
			// case "video"
			else if (ad.creative.format == "video") ad.creative.creativeFormat = SACreativeFormat.video;
			// case "rich_media" and "rich_media_resizing"
			else if (ad.creative.format.indexOf("rich_media") >= 0) ad.creative.creativeFormat = SACreativeFormat.rich;
			// case "tag" and "fallback_tag"
			else if (ad.creative.format.indexOf("tag") >= 0) ad.creative.creativeFormat = SACreativeFormat.tag;
			
			// create the tracking URL
			var trackingDict: Object = {
				"placement":ad.placementId,
				"line_item":ad.lineItemId,
				"creative":ad.creative.id,
				"sdkVersion":SuperAwesome.getInstance().getSdkVersion(),
				"rnd":SAUtils.getCacheBuster()
			};
			ad.creative.trackingUrl = SuperAwesome.getInstance().getBaseURL()
										+ (ad.creative.format == SACreativeFormat.video ? "/video/click?" : "/click?")
										+ SAUtils.formGetQueryFromObject(trackingDict);
			
			// create the viewable impression URL
			var impressionDict: Object = {
				"placement":ad.placementId,
				"line_item":ad.lineItemId,
				"creative":ad.creative.id,
				"type":"viewable_impression"
			};
			var impressionDict2: Object = {
				"sdkVersion":SuperAwesome.getInstance().getSdkVersion(),
				"rnd":SAUtils.getCacheBuster(),
				"data":SAUtils.encodeJSONDictionaryFromObject(impressionDict)
			};
			ad.creative.viewableImpressionUrl = SuperAwesome.getInstance().getBaseURL()
												+ "/event?"
												+ SAUtils.formGetQueryFromObject(impressionDict2);
			
			parse(ad);
		}
	}
	
}