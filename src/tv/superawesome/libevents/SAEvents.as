package tv.superawesome.libevents {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import tv.superawesome.libutils.SAUtils;

	public class SAEvents {
		// @brief: this is just a "dumb" function that sends a GET request to the
		// specified URL; it's a thing wrapper for SANetwork.sendGetToEndpoint() so that
		// it's fire-and-forget
		// @param: the URL to make the event request to
		public static function sendEventToURL(url: String): void {
			// make sure URL is not Null
			if (url == null) return;
			
			// send GET
			SAUtils.sendGET(url, null, function(e: Event): void {
				trace("[OK] Event:" + url);
			}, function(io: IOErrorEvent): void {
				trace(io);
				trace(io.target);
				trace("\t[NOK] Event:\t"+url);
			});
		}
	}
}