package tv.superawesome.libvast {
	public interface SAVASTManagerInterface {
		// Called when the VAST data could not be parsed at all
		function didNotFindAds(): void ;
		
		// Called when an Ad from a group of Ads has just started playing
		function didStartAd(): void ;
		
		// Called when a creative from the current Ad has started playing
		function didStartCreative(): void ;
		
		// Called when 1/4 of a creative's length has passed
		function didReachFirstQuartileOfCreative(): void ;
		
		// Called when 1/2 of a creative's length has passed
		function didReachMidpointOfCreative(): void;
		
		// Called when 3/4 of a creative's length has passed
		function didReachThirdQuartileOfCreative(): void;
		
		// Called when a creative from the current Ad has finished playing
		function didEndOfCreative():void;
		
		// Called when a creative could not be played (due to corrupt resource on the network, wifi problems, etc)
		function didHaveErrorForCreative(): void;
		
		// Called when an ad has played all its creatives
		function didEndAd(): void;
		
		// Called when all ads and all creative have played
		function didEndAllAds(): void;
		
		// Goto URL
		function didGoToURL(url: String, clickTracking:Array): void;
	}
}