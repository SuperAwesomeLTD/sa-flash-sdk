//
//  SAFormatter.h
//  tv.superawesome.Data.Parser
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Parser {
	
	// imports for this class
	import flash.utils.ByteArray;
	
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.AdParser.Models.SAAd;
	import tv.superawesome.sdk.AdParser.Models.SACreativeFormat;
	
	// @brief:
	// This class contains class functions that generate the HTML for
	// image, rich media and tag ads that need to be rendered in a WebView
	public class SAHTMLParser {
		
		// constructor that does nothing
		public function SAHTMLParser(){
			// do nothing
		}
		
		public static function formatCreativeDataIntoAdHTML(ad: SAAd): String {
			
			switch (ad.creative.format) {
				case SACreativeFormat.image: {
					return formatCreativeIntoImageHTML(ad);
					break;
				}
				case SACreativeFormat.video: {
					return null;
					break;
				}
				case SACreativeFormat.rich: {
					return formatCreativeIntoRichMediaHTML(ad);
					break;
				}
				case SACreativeFormat.tag: {
					return formatCreativeIntoTagHTML(ad);
					break;
				}
				default: {
					return null;
					break;
				}
			}
			
			return null;
		}
		
		
		private static function formatCreativeIntoImageHTML(ad: SAAd): String {
//			// load the template
//			[Embed('../../../../resources/displayImage.html', mimeType="application/octet-stream")] var myReferenceFile:Class;
//			var bundleFileBytes: ByteArray = new myReferenceFile();
//			var template: String = bundleFileBytes.toString();
//			
//			// return the template
//			template = template.replace("imageURL", ad.creative.details.image);
//			template = template.replace("hrefURL", ad.creative.clickURL);
//			return template;
			return "";
		}
		
		private static function formatCreativeIntoRichMediaHTML(ad: SAAd): String {
//			// load the template
//			[Embed('../../../../resources/displayRichMedia.html', mimeType="application/octet-stream")] var myReferenceFile:Class;
//			var bundleFileBytes: ByteArray = new myReferenceFile();
//			var template: String = bundleFileBytes.toString();
//			
//			// form the template parameters
//			var objJSON: Object = {
//				"placement":ad.placementId,
//				"line_item":ad.lineItemId,
//				"creative":ad.creative.creativeId,
//				"sdkVersion":SuperAwesome.getInstance().getSdkVersion(),
//				"rnd":SAAux.getCacheBuster()
//			};
//			var richMediaString: String = ad.creative.details.url + "?" + SAAux.formGetQueryFromObject(objJSON);
//			
//			// return the parametrized template
//			return template.replace("_PARAM_URL_", richMediaString);
			return "";
		}
		
		private static function formatCreativeIntoTagHTML(ad: SAAd): String {
//			// form the template
//			[Embed('../../../../resources/displayTag.html', mimeType="application/octet-stream")] var myReferenceFile:Class;
//			var bundleFileBytes: ByteArray = new myReferenceFile();
//			var template: String = bundleFileBytes.toString();
//			
//			// form the template parameters
//			var tagString: String = ad.creative.details.tag;
//			tagString.replace("[click]", ad.creative.trackingURL+"&redir=");
//			tagString.replace("[click_enc]", encodeURI(ad.creative.trackingURL));
//			tagString.replace("[keywords]", "");
//			var dt:Date = new Date();
//			tagString.replace("[timestamp]", dt.valueOf().toString());
//			tagString.replace("target=\"_blank\"", "");
//			
//			// return the parametrized template
//			return template.replace("tagdata", tagString);
			return "";
		}
		
	}
}