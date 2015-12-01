package tv.superawesome {
	
	import flash.system.Security;

	public class SuperAwesome extends SuperAwesomeCommon {
		
		// singleton part
		private static var _instance: SuperAwesome;
		
		public function SuperAwesome() {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			
			// enable cross domain and default values
			this.allowCrossdomain();
			this.enableTestMode();
			this.setConfigurationProduction();
			
			// instrance
			_instance = this;
		}
		
		public static function getInstance(): SuperAwesome {
			if (!_instance) { new SuperAwesome(); }
			return _instance;
		}
		
		// public (useful) functions
		override public function version(): String {
			return "3.0";
		}
		
		override public function platform(): String {
			return "flash";
		}
		
		public function allowCrossdomain(): void {
			var crossDomainURL: String = SuperAwesomeCommon.getInstance().getBaseURL().replace("/v2","") + "/crossdomain.xml";
			var googleCrossDomain: String = "http://imasdk.googleapis.com/crossdomain.xml";
			Security.allowDomain("*");
			Security.loadPolicyFile(crossDomainURL);
			Security.loadPolicyFile(googleCrossDomain);
			Security.loadPolicyFile("http://ads.superawesome.tv/crossdomain.xml");
			Security.loadPolicyFile("https://imasdk.googleapis.com/crossdomain.xml");
			trace(googleCrossDomain);
		}
	}
}