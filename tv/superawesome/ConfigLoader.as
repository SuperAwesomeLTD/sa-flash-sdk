package tv.superawesome {
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.utils.Dictionary;

	public class ConfigLoader {

		private static var _instance: ConfigLoader;

		private var configs: Dictionary = new Dictionary();
		private var callbacks: Dictionary = new Dictionary();
		private var loaders: Dictionary = new Dictionary();

		public function ConfigLoader() {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}

		public static function getInstance(): ConfigLoader {
			if (!_instance) {
				new ConfigLoader();
			}
			return _instance;
		}

		public function loadConfig(appID: String, callback:Function) {
			trace("Load config for "+appID)
			if(configs[appID]){
				trace("Already loaded");
				callback(configs[appID]);
			}else{
				if(!callbacks[appID]){
					callbacks[appID] = new Array();
				}
				callbacks[appID].push(callback)
				
				var request: URLRequest = new URLRequest();
				request.url = "http://dashboard.superawesome.tv/api/sdk/mobile/ads";
				var rhArray: Array = new Array(new URLRequestHeader("Content-Type", "application/json"));
				request.requestHeaders = rhArray;
				request.method = URLRequestMethod.POST;
				request.data = "{\"app_id\":"+appID+"}";
				var loader = new URLLoader();
				loaders[loader] = appID;
				loader.addEventListener(Event.COMPLETE, onConfigLoaded);
				loader.load(request);
			}
		}

		public function getVideoAd(appID: String, placementID: String, callback:Function) {
			loadConfig(appID, function(config){
				for each (var ad:Object in config.prerolls) {
					if(String(ad.id) == placementID){
						callback(ad)
						return;
					}
				}
				trace("Placement could not be found");
			});
		}

		private function onConfigLoaded(e: Event): void {
			var loader = e.target;
			var appID = loaders[loader];
			var config: Object = JSON.parse(loader.data);
			configs[appID] = config;
			for each (var callback:Function in callbacks[appID]) {
				callback(config);
			}
		}

	}
}