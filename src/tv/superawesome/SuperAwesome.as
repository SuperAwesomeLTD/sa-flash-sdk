package tv.superawesome {
	public class SuperAwesome {
		// other vars
		private var baseURL: String;
		
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
		public function getBaseURL() {
			return this.baseURL;
		}
		
		public function setConfigProduction() {
			baseURL = "https://ads.superawesome.tv/";
		}
		
		public function setConfigStaging() {
			baseURL = "https://staging.beta.ads.superawesome.tv/";
		}
		
		public function setConfigDevelopment() {
			baseURL = "https://dev.ads.superawesome.tv/";
		}
	}
}