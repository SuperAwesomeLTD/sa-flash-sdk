//
//  SADetails.h
//  tv.superawesome.Data.Models
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

package tv.superawesome.sdk.Models {
	
	// @brief:
	// The SADetails class contains fine grained information about the creative
	// of an ad (such as width, iamge, vast, tag, etc)
	// Depending on the format of the creative, some fields are essential,
	// and some are optional
	//
	// This dependency is regulated by SAValidator.h
	public class SADetails {
		// the width & height of the creative; can be applied to images, banners,
		// rich-media, etc
		// there are cases when this is 1 x 1 - which indicates a relative-size
		// creative
		public var width: int;
		public var height: int;
		
		// in case creative format is image_with_link, this is the URL of the image
		public var image: String;
		
		// aux value needed when sending ad data like rating and such
		public var value: int;
		
		// name of the creative
		public var name: String;
		
		// in case creative format is video, this is the URL of the video to be streamed
		public var video: String;
		
		// in case creative format is video, this is the video bitrate
		public var bitrate: int;
		
		// in case creative format is video, this is the total duration
		public var duration: int;
		
		// in case creative format is video, this is the associated vast tag
		public var vast: String;
		
		// in case creative format is tag, this is the JS tag
		public var tag: String;
		
		// in case creative format is rich media, this is the URL to the zip with all
		// media resources; at the moment it's not used, but could be used when doing
		// truly preloaded ads
		public var zipFile: String;
		
		// in case creative format is rich media, this is the URL of the rich media
		public var url: String;
		
		// this is the placement format, defined in SAPlacementFormat.h
		// as of now, it's kind of useless
		public var placementFormat: String;
		
		// the details data
		public var data:SAData = null;
		
		// constructor
		public function SADetails() {
			// do nothing
		}
		
		// aux print function
		public function print(): void {
			trace("\tDetails:");
			trace("\t\twidth: " + this.width);
			trace("\t\theight: " + this.height);
			trace("\t\timage: " + this.image);
			trace("\t\tvalue: " + this.value);
			trace("\t\tname: " + this.name);
			trace("\t\tvideo: " + this.video);
			trace("\t\tbitrate: " + this.bitrate);
			trace("\t\tduration: " + this.duration);
			trace("\t\tvast: " + this.vast);
			trace("\t\ttag: " + this.tag);
			trace("\t\tzip: " + this.zipFile);
			trace("\t\turl: " + this.url);
			trace("\t\tplacementFormat: " + this.placementFormat);
			data.print();
		}
	}
}