//
//  SACreative.h
//  tv.superawesome.Data.Models
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

package tv.superawesome.sdk.AdParser.Models {
	
	// @brief:
	// The creative contains essential ad information like format, click url
	// and such
	public class SACreative {
		// the creative ID is a unique ID associated by the server with this Ad
		public var creativeId: int;
		
		// name of the creative - set by the user in the dashboard
		public var name: String;
		
		// agreed upon CPM; not really a useful field
		public var cpm: int;
		
		// the creative format defines the type of ad (image, video, rich media, tag, etc)
		// and is an enum defined in SACreativeFormat.h
		public var baseFormat: String;
		public var format: String;
		
		// the impression URL; not really useful because it's used server-side
		public var impresionURL: Array;
		
		// the viewable impression URL; used by the SDK to track a viewable impression
		public var viewableImpressionURL: String;
		
		// the click URL - taken from the ad server; it's the direct target to
		// which the ad points, if it exists
		public var clickURL: String;
		
		// the tracking URL
		public var trackingURL: String;
		
		// the tracking URL used when video is complete - used by the AIR SDK
		// which currently does not have Google IMA SDK integration
		public var videoCompleteURL: Array = new Array();
		
		// new array of click tracking elements
		public var videoClickTrackingURLs: Array = new Array();
		
		// must be always true for real ads
		public var approved: Boolean;		
		
		// pointer to a SADetails object containing even more creative information
		public var details: SADetails;
		
		// again used, for video ads, to determine if an Ad is a Wrapper or not
		public var isWrapper: Boolean = false;
		
		// constructor
		public function SACreative() {
			// do nothing
		}
		
		// aux print function
		public function print(): void {
			trace("Creative:");
			trace("\tCreativeId: " + this.creativeId);
			trace("\tname: " + this.name);
			trace("\tcpm: " + this.cpm);
			trace("\tbaseFormat: " + this.baseFormat);
			trace("\tformat: " + this.format);
			trace("\timpressionURL: " + this.impresionURL);
			trace("\tviewableImpressionURL: " + this.viewableImpressionURL);
			trace("\tclickURL: " + this.clickURL);
			trace("\ttrackingURL: " + this.trackingURL);
			trace("\tvideoCompleteURL: " + this.videoCompleteURL);
			trace("\tvideoClickTrackingURLs: "+ this.videoClickTrackingURLs);
			trace("\tapproved: " + this.approved);
			trace("\tbaseFormat: " + this.baseFormat);
			trace("\tformat: " + this.format);
			trace("\tisWrapper: " + this.isWrapper);
			details.print();
		}
	}
}