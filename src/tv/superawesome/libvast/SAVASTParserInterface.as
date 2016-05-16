package tv.superawesome.libvast {
	
	// imports
	import tv.superawesome.libvast.savastmodels.SAVASTAd;

	//
	// @brief: The SAVASTParserProtocol implements two functions
	public interface SAVASTParserInterface {
		//
		// @brief: called as a callback when there are valid ads to be displayed
		function didParseVAST(ad: SAVASTAd): void
	}
}