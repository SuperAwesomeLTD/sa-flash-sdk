//
//  SACreativeFormat.h
//  tv.superawesome.Data.Models
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

package tv.superawesome.sdk.AdParser.Models {
	
	// @brief: this class acts as an ActionScript "enum" of constant values
	// that depict all the supported creative formats
	final public class SACreativeFormat {
		
		// default value
		public static const invalid: String = "invalid";
		
		// real-life values
		public static const image: String = "image";
		public static const video: String = "video";
		public static const rich: String = "rich";
		public static const tag: String = "tag";
	}
}