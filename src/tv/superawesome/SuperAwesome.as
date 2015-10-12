package tv.superawesome {
	public class SuperAwesome {
		// other vars
		private var baseURL: String;
		private var isTest: Boolean;
		
		// singleton var
		private static var _instance: SuperAwesome;
		
		// constructor
		public function SuperAwesome() {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}

		// get instance function
		public static function getInstance(): SuperAwesome {
			if (!_instance) {
				new SuperAwesome();
			}
			return _instance;
		}
		
		// public functions
		public function getBaseURL(): String {
			return this.baseURL;
		}
		
		public function setConfigProduction(): void {
			baseURL = "https://ads.superawesome.tv";
		}
		
		public function setConfigStaging(): void {
			baseURL = "https://staging.beta.ads.superawesome.tv";
		}
		
		public function setConfigDevelopment(): void {
			baseURL = "https://dev.ads.superawesome.tv";
		}
		
		public function enableTestMode(): void {
			isTest = true;
		}
		
		public function disableTestMode(): void {
			isTest = false;
		}
		
		public function getTestMode(): Boolean {
			return isTest;
		}
	}
}