package tv.superawesome.libvast.savastmodels {
	public class SAVASTMediaFile {
		
		public var width: String = null;
		public var height: String = null;
		public var type: String = null;
		public var URL: String = null;
		public var apiFramework: String = null;
		
		public function SAVASTMediaFile() {
		}
		
		public function printy (): void {
			trace("Type is " + type + " and URL is " + URL);
		}
	}
}