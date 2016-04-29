package tv.superawesome.sdk.Views {
	public interface SAVideoAdInterface {
		
		// fired when an ad has started
		function adStarted(placementId: int): void;
		
		// fired when a video ad has started
		function videoStarted(placementId: int): void;
		
		// fired when a video ad has reached 1/4 of total duration
		function videoReachedFirstQuartile(placementId: int): void;
		
		// fired when a video ad has reached 1/2 of total duration
		function videoReachedMidpoint(placementId: int): void;
		
		// fired when a video ad has reached 3/4 of total duration
		function videoReachedThirdQuartile(placementId: int): void;
		
		// fired when a video ad has ended
		function videoEnded(placementId: int):void;
		
		// fired when an ad has ended
		function adEnded(placementId: int):void;
		
		// fired when all ads have ended
		function allAdsEnded(placementId: int):void;
		
	}
}