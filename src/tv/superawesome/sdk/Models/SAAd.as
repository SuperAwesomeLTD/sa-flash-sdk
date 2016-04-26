//
//  SAAd.h
//  tv.superawesome.Data.Models
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

package tv.superawesome.sdk.Models {
	
	// @brief:
	// This model class contains all information that is received from the server
	// when an Ad is requested, as well as some aux fields that will be generated
	// by the SDK
	public class SAAd {
		
		// the SA server can send an error; if that's the case, this field will not be nill
		public var error: int = -1;
		
		// the app id
		public var app: int = -1;
		
		// the ID of the placement that the ad was sent for
		public var placementId: int = 0;
		
		// line item - the subcampaign the ad is part of
		public var lineItemId: int = -1;
		
		// the ID of the campaign that the ad is a part of
		public var campaignId: int = -1;
		
		// is true when the ad is a test ad
		public var test: Boolean = false;
		
		// is true when ad is fallback (fallback ads are sent when there are no
		// real ads to display for a certain placement)
		public var isFallback: Boolean = false;
		public var isFill: Boolean = true;
		public var isHouse: Boolean = false;
		
		// pointer to the creative data associated with the ad
		public var creative: SACreative;
		
		// default empty constructor
		public function SAAd() {
			// do nothing
		}
		
		// aux print function
		public function print(): void {
			trace("Ad with placement " + this.placementId);
			trace("error: " + error);
			trace("placementId: " + this.placementId);
			trace("lineItemId: " + this.lineItemId);
			trace("campaignId: " + this.campaignId);
			trace("isTest: " + this.test);
			trace("isFallback : " + this.isFallback);
			trace("isFill: " + this.isFill);
			creative.print();
		}
	}
}