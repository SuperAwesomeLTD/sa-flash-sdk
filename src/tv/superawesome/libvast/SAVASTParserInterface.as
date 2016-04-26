package tv.superawesome.libvast {
	//
	// @brief: The SAVASTParserProtocol implements two functions
	public interface SAVASTParserInterface {
		//
		// @brief: called as a callback when there are valid ads to be displayed
		function didParseVAST(ads: Array): void
	}
}