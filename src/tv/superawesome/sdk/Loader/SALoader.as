//
//  SALoader.h
//  tv.superawesome.Data.Loader
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//
package tv.superawesome.sdk.Loader {
	
	// imports
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.sdk.Parser.SAParser;

	// @brief:
	// This is a loader class that acts as Master loading class
	// It's main purpose if to be called either by the SDK user or by SAAd
	// to perform loading and preloading of ads
	//
	// It can preload ads using the SALoaderProtocol and - (void) preloadAdForPlacementId:
	//
	// The direct ad loading functions are hidden from the user
	//
	public class SALoader {
		// the delegate
		public var delegate: SALoaderInterface;
		
		// declare the parser
		private var parser:SAParser = null;
		
		// and the extra data loader
		private var extra:SALoaderExtra = null;
		
		public function SALoader() {
			// create the parser
			parser = new SAParser();
			
			// and extra data loader
			extra = new SALoaderExtra();
		}

		// function that loads an ad
		public function loadAd(placementId: int): void {
			
			// form the URL
			var endpoint: String = SuperAwesome.getInstance().getBaseURL() + "/ad/" + placementId;
			var dict: Object = {
				"test": SuperAwesome.getInstance().isTestingEnabled(),
				"sdkVersion": SuperAwesome.getInstance().getSdkVersion(),
				"rnd": SAUtils.getCacheBuster()
			};
			
			// send a get to load the actual AD
			SAUtils.sendGET(endpoint, dict, function(e: Event): void { 
				
				// start the heavy lifting
				var config: Object = com.adobe.serialization.json.JSON.decode(e.target.data);
				var ad:SAAd = parser.parseDictionary(config, placementId);
				
				if (ad != null) {
					extra.getExtraData(ad, function(finalAd:SAAd): void {
						success(ad);
					});
				} else {
					error(placementId);
				}
			}, 
			function(): void { 
				error(placementId);
			});
		}		
		
		// @brief: shorthand function to denote success and check for delegate implementation
		private function success(ad: SAAd): void{
			if (delegate != null) {
				delegate.didLoadAd(ad);
			}
		}
		
		// @brief: shorthand function to denote error and check for delegate implementation
		private function error(placementId: int): void {
			if (delegate != null) {
				delegate.didFailToLoadAd(placementId);
			}
		}
	}
}