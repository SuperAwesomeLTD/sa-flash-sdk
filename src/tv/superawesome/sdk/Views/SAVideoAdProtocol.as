//
//  SAVideoProtocol.h
//  tv.superawesome.Views.Protocols
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

package tv.superawesome.sdk.Views {
	
	// @brief:
	// This is the SAVideoProtocol implementation, that defines a series of
	// functions that might be of interest to SDK users who want to have specific
	// actions in case of video events
	public interface SAVideoAdProtocol {
		
		// fired when a video ad has started
		function videoStarted(placementId: int): void;
		
		// fired when a video ad has reached 1/4 of total duration
		function videoReachedFirstQuartile(placementId:int): void;
		
		// fired when a video ad has reached 1/2 of total duration
		function videoReachedMidpoint(placementId:int): void;
		
		// fired when a video ad has reached 3/4 of total duration
		function videoReachedThirdQuartile(placementId: int): void;
		
		// fired when a video ad has ended
		function videoEnded(placementId:int): void;
	}
}