//
//  SuperAwesome.h
//  tv.superawesome
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//
package tv.superawesome.sdk {
	
	// import needed for this class
	import flash.system.Security;

	// 
	// @brief: this class is a descendant of SuperAwesomeCommon
	// that implements Flash SDK specific functionality
	public class SuperAwesome  {
		
		// URL constants
		private static const BASE_URL_STAGING: String = "https://ads.staging.superawesome.tv/v2";
		private static const BASE_URL_DEVELOPMENT: String = "https://ads.dev.superawesome.tv/v2";
		private static const BASE_URL_PRODUCTION: String = "https://ads.superawesome.tv/v2";
		
		// private variables
		private var baseURL: String;
		private var isTestEnabled: Boolean;
		
		// singleton part
		private static var _instance: SuperAwesome;
		
		// the constructor, which acts as a Singleton
		public function SuperAwesome() {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			// instrance
			_instance = this;
			
			// enable cross domain and default values
			disableTestMode();
			setConfigurationProduction();
			allowCrossdomain();
		}
		
		// main accessor function
		public static function getInstance(): SuperAwesome {
			if (!_instance) { new SuperAwesome(); }
			return _instance;
		}
		
		// public (useful) functions
		public function getVersion(): String {
			return "3.1.8";
		}
		
		public function getSdk(): String {
			return "flash";
		}
		
		public function getSdkVersion(): String {
			return getSdk() + "_" + getVersion();
		}
		
		public function setConfigurationProduction(): void {
			this.baseURL = BASE_URL_PRODUCTION;
		}
		
		public function setConfigurationStaging(): void {
			this.baseURL = BASE_URL_STAGING;
		}
		
		public function setConfigurationDevelopment(): void {
			this.baseURL = BASE_URL_DEVELOPMENT;
		}
		
		public function getBaseURL(): String {
			return this.baseURL;
		}
		
		public function enableTestMode(): void {
			this.isTestEnabled = true;
		}
		
		public function disableTestMode(): void {
			this.isTestEnabled = false;
		}
		
		public function isTestingEnabled(): Boolean {
			return this.isTestEnabled;
		}
		
		// 
		// @brief: function that handles crossdomain for Flash
		// it takes into account SA crossdomain.xml as well as some google and
		// Google IMA SDK ones
		public function allowCrossdomain(): void {
			var crossDomainURL: String = getBaseURL().replace("/v2","") + "/crossdomain.xml";
			var googleCrossDomain: String = "http://imasdk.googleapis.com/crossdomain.xml";
			Security.allowDomain("*");
			Security.loadPolicyFile(crossDomainURL);
			Security.loadPolicyFile(googleCrossDomain);
			trace(crossDomainURL);
		}
	}
}