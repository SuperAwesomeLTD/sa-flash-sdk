package tv.superawesome.libvast {
	//
	// @brief: The SAVASTParserProtocol implements two functions
	public interface SAVASTParserProtocol {
		//
		// @brief: called as a callback when there are valid ads to be displayed
		function didParseVASTAndHasAdsResponse(ads: Array): void
		
		//
		// @brief: called as a callback when there are no valid ads to be displayed
		function didNotFindAnyValidAds(): void
		
		//
		// @brief: this should be called when the VAST response is entirely corrupted
		// for one reason or another
		function didFindInvalidVASTResponse(): void
	}
}