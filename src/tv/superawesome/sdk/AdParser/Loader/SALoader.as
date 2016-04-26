//
//  SALoader.h
//  tv.superawesome.Data.Loader
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Loader {
	
	// imports
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	
	import tv.superawesome.sdk.SuperAwesome;
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.AdParser.Models.SAAd;
	import tv.superawesome.sdk.AdParser.Parser.SAParser;
	import tv.superawesome.sdk.AdParser.Validator.SAValidator;

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
		
		public function SALoader() {
			
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
				
				if (config) {
					// we invoke SAParser class functions to parse different aspects
					// of the Ad
					SAParser.parseDictionary(config, placementId, function(ad: SAAd): void {
						// one final check for validity
						var isValid:Boolean = SAValidator.isAdDataValid(ad);
						
						if (isValid) {
							success(ad);
						} else {
							error(placementId);
						}
					});
				}
				else {
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