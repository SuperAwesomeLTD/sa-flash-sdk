//
//  SACreative.h
//  tv.superawesome.Data.Models
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

package tv.superawesome.sdk.Models {
	
	// @brief:
	// The creative contains essential ad information like format, click url
	// and such
	public class SACreative {
		
		// the creative ID is a unique ID associated by the server with this Ad
		public var id: int = -1;
		
		// name of the creative - set by the user in the dashboard
		public var name: String;
		
		// agreed upon CPM; not really a useful field
		public var cpm: int = 0;
		
		// the creative format defines the type of ad (image, video, rich media, tag, etc)
		// and is an enum defined in SACreativeFormat.h
		public var format: String;
		
		// the impression URL; not really useful because it's used server-side
		public var impresionUrl: Array;
		
		// the click URL - taken from the ad server; it's the direct target to
		// which the ad points, if it exists
		public var clickUrl: String;
		
		// must be always true for real ads
		public var approved: Boolean = true;	
		
		// is it live
		public var live: Boolean = true;
		
		// pointer to a SADetails object containing even more creative information
		public var details: SADetails;
		
		// the viewable impression URL; used by the SDK to track a viewable impression
		public var creativeFormat: String;
		
		// viewable impression URL
		public var viewableImpressionUrl: String;
		
		// the tracking URL
		public var trackingUrl: String;
		
		// constructor
		public function SACreative() {
			// do nothing
		}
		
		// aux print function
		public function print(): void {
			trace("Creative:");
			trace("\tid: " + this.id);
			trace("\tname: " + this.name);
			trace("\tcpm: " + this.cpm);
			trace("\tbaseFormat: " + this.format);
			trace("\timpressionURL: " + this.impresionUrl);
			trace("\tclickURL: " + this.clickUrl);
			trace("\tapproved: " + this.approved);
			trace("\tlive: " + this.live);
			trace("\ttrackingURL: " + this.trackingUrl);
			trace("\tformat: " + this.creativeFormat);
			trace("\tviewableImpressionURL: " + this.viewableImpressionUrl);
			details.print();
		}
	}
}