//
//  SuperAwesome.h
//  tv.superawesome
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//
package tv.superawesome {
	
	// import needed for this class
	import flash.system.Security;

	// 
	// @brief: this class is a descendant of SuperAwesomeCommon
	// that implements Flash SDK specific functionality
	public class SuperAwesome extends SuperAwesomeCommon {
		
		// singleton part
		private static var _instance: SuperAwesome;
		
		// the constructor, which acts as a Singleton
		public function SuperAwesome() {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			
			// enable cross domain and default values
			this.allowCrossdomain();
			this.disableTestMode();
			this.setConfigurationProduction();
			
			// instrance
			_instance = this;
		}
		
		// main accessor function
		public static function getInstance(): SuperAwesome {
			if (!_instance) { new SuperAwesome(); }
			return _instance;
		}
		
		// public (useful) functions
		override public function getVersion(): String {
			return "3.1.0";
		}
		
		override public function getSdk(): String {
			return "flash";
		}
		
		// 
		// @brief: function that handles crossdomain for Flash
		// it takes into account SA crossdomain.xml as well as some google and
		// Google IMA SDK ones
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