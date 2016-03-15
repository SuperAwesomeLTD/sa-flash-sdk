//
//  SAAux.h
//  tv.superawesome.Aux
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//
package tv.superawesome.libutils {

	// needed imports for this class
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	// @brief: spublic class full of aux static methods
	public class SAUtils {
		
		// calculate a random integer between two bounds
		public static function randomIntBetween(min: int, max: int): int {
			return min + (max - min) * Math.random();
		}
		
		// the cache buster is just a large random number
		public static function getCacheBuster(): int{
			return randomIntBetween(1000000, 1500000);
		}
		
		// calculate a frame from another (base) frame
		// used by the rendering parts of the code to scale up or down the ad content when dealing
		// with multiple sizes and screens
		public static function arrangeAdInNewFrame(frame: Rectangle, fromFrame: Rectangle): Rectangle {
			var newW: Number = frame.width;
			var newH: Number = frame.height;
			var oldW: Number = fromFrame.width;
			var oldH: Number = fromFrame.height;
			if (oldW == 1 || oldW == 0) { oldW = newW; }
			if (oldH == 1 || oldH == 0) { oldH = newH; }
			
			var oldR: Number = oldW / oldH;
			var newR: Number = newW / newH;
			
			var W: Number = 0, H: Number = 0, X: Number = 0, Y: Number = 0;
			
			if (oldR > newR) {
				W = newW;
				H = W / oldR;
				X = 0;
				Y = (newH - H) / 2;
			}
			else {
				H = newH;
				W = H * oldR;
				Y = 0;
				X = (newW - W) / 2;
			}
			
			return new Rectangle(X, Y, W, H);
		}
		
		//
		// not really used - this one
		public static function findSubstringBetweenStartAndEnd(source: String, start: String, end: String): String {
			var startIndex: Number = source.indexOf(start);
			var endIndex: Number = source.indexOf(end);
			
			// do some checkups here
			return source.slice(startIndex, endIndex);
		}
		
		// form a Get Query string from the contents of a dictionary
		public static function formGetQueryFromObject(dict: Object): String {
			var getEndpoint: String = "";
			
			for (var i:* in dict) { 
				getEndpoint += i + "=" + dict[i] + "&" ; 
			}
			
			if (getEndpoint.length > 1) {
				return getEndpoint.substring(0, getEndpoint.length - 1);
			} else {
				return "";
			}
		}
		
		// encode an ActionScript Object as a JSON encoded string - ready to append to a URL
		public static function encodeJSONDictionaryFromObject(dict: Object): String {
			return com.adobe.serialization.json.JSON.encode(dict);
		}
		
		// function that checks if an object has any fields or not
		public static function isEmptyObject(dict: Object):Boolean {
			for (var s:* in dict) {
				return false;
				break;
			}
			
			return true;
		}
		
		// function that uses a regex to determine if a URL is valid or not
		public static function isValidURL(url: String):Boolean {
			var regex:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
			return regex.test(url); // returns true if valid url is found
		}
		
		// function that returns a filename extension
		public static function returnExtension(filename: String): String {
			return filename.substring(filename.lastIndexOf(".")+1, filename.length);
		}
		
		// function that gets an array as parameter and returns an array
		// that only contains the first element
		public static function removeAllButFirstElement(array:Array): Array {
			var result:Array = new Array();
			if (array.length >= 1) {
				result.push(array[0]);
			}
			return result;
		}
		
		// @brief:
		// perform POST request to server
		// @params:
		//  - endpoint: the URL to send the POST request to; must be full URL e.g. http://google.com
		//  - POSTDict: a key-value dictionary that will get transformed to POST body
		//  - success: callback function when the POST request has succedded; cannot be nil;
		//  - failure: callback in case of error; can be nil;
		public static function sendGET(endpoint: String, queryDict: Object, success: Function, error: Function): void {
			
			// form the full GET-ified endpoint
			var getEndpoint: String = endpoint;
			if (queryDict != null) {
				getEndpoint += "?";
				getEndpoint += SAUtils.formGetQueryFromObject(queryDict);
			}
			
			// form the request 
			var request: URLRequest = new URLRequest(getEndpoint);
			request.requestHeaders = new Array();
			
			// request different headers
			var contentTypeHeader: URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");
			request.requestHeaders.push(contentTypeHeader);
			
			// create the loader and make the actual request
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, success);
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			try {
				loader.load(request);
			} catch (e: *) {
				error();
			}
		}
	}
}