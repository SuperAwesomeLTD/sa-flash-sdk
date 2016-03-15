﻿//
//  SALoaderProtocol.h
//  tv.superawesome.Data.Loader
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Loader {
	
	// imports for this interface
	import tv.superawesome.sdk.AdParser.Models.SAAd;
	
	// @brief:
	// SALoader interface defines two main optional functions that a user might
	// implement if he wants to preload Ads
	// This protocol is implemented by a SALoader class delegate
	public interface SALoaderProtocol {
		
		// @brief: function that gets called when an Ad is succesfully called
		// @return: returns a valid SAAd object
		function didLoadAd(ad: SAAd): void;
		
		// @brief: function that gets called when an Ad has failed to load
		// @return: it returns a placementId of the failing ad through callback
		function didFailToLoadAdForPlacementId(placementId:int): void;
	}
}