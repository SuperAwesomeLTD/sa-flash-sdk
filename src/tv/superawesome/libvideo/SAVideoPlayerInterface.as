package tv.superawesome.libvideo {
	public interface SAVideoPlayerInterface {
		
		//
		// @brief: player ready
		function didFindPlayerReady(): void;
		
		//
		// @brief: called when the player starts
		function didStartPlayer(): void;
		
		//
		// @brief: called when the player reaches 1/4 of playing time
		function didReachFirstQuartile(): void;
		
		//
		// @brief: called when the player reaches 1/2 of playing time
		function didReachMidpoint(): void;
		
		//
		// @brief: called when the player reaches 3/4 of playing time
		function didReachThirdQuartile(): void;
		
		//
		// @brief: called when the player reaches the end of playing time
		function didReachEnd(): void;
		
		//
		// @brief: called when the player terminates with error
		function didPlayWithError(): void;
		
		//
		// @brief: go to URL
		function didGoToURL(): void;
	}
}