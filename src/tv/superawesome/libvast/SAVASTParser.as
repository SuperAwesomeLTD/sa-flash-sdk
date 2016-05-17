package tv.superawesome.libvast {
	// imports for this class
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.libvast.SAXMLLib;
	import tv.superawesome.libvast.savastmodels.SAAdType;
	import tv.superawesome.libvast.savastmodels.SAVASTAd;
	import tv.superawesome.libvast.savastmodels.SAVASTCreative;
	import tv.superawesome.libvast.savastmodels.SAVASTCreativeType;
	import tv.superawesome.libvast.savastmodels.SAVASTMediaFile;
	import tv.superawesome.libvast.savastmodels.SAVASTTracking;

	// 
	// the main VAST Parser class
	// that should handle "simple" inline and wrapper ads
	public class SAVASTParser {
		
		// public vars
		public var delegate: SAVASTParserInterface = null;
		
		// main public function
		public function parseVASTURL(url: String): void {
			parseVASTAync(url, function (ad: SAVASTAd): void {
				if (delegate != null) {
					delegate.didParseVAST(ad);
				}
			});
		}
		
		// callback function way
		public function parseVASTURL2(url:String, callback:Function = null): void {
			parseVASTAync(url, function (ad: SAVASTAd): void {
				if (callback != null) {
					callback(ad);
				}
			});
		}
		
		// private function
		private function parseVASTAync(url: String, callback: Function = null): void {
			// parse the URL
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.load(new URLRequest (url));
			
			// success case
			xmlLoader.addEventListener(Event.COMPLETE, function (e:Event): void {
				// first error check
				if (e == null || e.target == null || e.target.data == null) {
					callback(null); return;
				}
				
				// get root element
				var root: XML = new XML(e.target.data);
				
				// second error check
				if (root == null) {
					callback(null); return;
				}
				if (!SAXMLLib.checkSiblingsAndChildren(root, "Ad")) {
					callback(null); return;
				}
					
				// continue ad parsing
				var element: XML = SAXMLLib.findFirstInstanceInSiblingsAndChildren(root, "Ad");
				var ad:SAVASTAd = parseAdXML(element);
				
				if (ad.type == SAAdType.InLine) {
					callback(ad);
					return;
				} else if (ad.type == SAAdType.Wrapper) {
					parseVASTAync(ad.redirectUri, function(wrapper:SAVASTAd):void {
						
						if (wrapper != null) {
							wrapper.sumAd(ad);
						}
						
						callback(wrapper);
						return;
					});
				} else {
					callback(null);
					return;
				}
			});
			
			// error cases
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent): void {
				callback(null);
			});
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent): void {
				callback(null);
			});
		}
		
		//
		// parse main ad body
		public function parseAdXML(element: XML): SAVASTAd {
			var ad: SAVASTAd = new SAVASTAd();
			ad.id = element.attribute("id");
			ad.sequence = element.attribute("sequence");
			
			var isInLine:Boolean = SAXMLLib.checkSiblingsAndChildren(element, "InLine");
			var isWrapper:Boolean = SAXMLLib.checkSiblingsAndChildren(element, "Wrapper");
			
			if (isInLine) ad.type = SAAdType.InLine;
			if (isWrapper) ad.type = SAAdType.Wrapper;
			
			var tagURIElement: XML = SAXMLLib.findFirstInstanceInSiblingsAndChildren(element, "VASTAdTagURI");
			if (tagURIElement != null) {
				ad.redirectUri = tagURIElement.toString();
			}
			
			SAXMLLib.searchSiblingsAndChildrenInterate(element, "Error", function(xml: XML):void {
				ad.Errors.push(xml.toString());
			});
			
			SAXMLLib.searchSiblingsAndChildrenInterate(element, "Impression", function(xml: XML): void {
				ad.Impressions.push(xml.toString());
			});
			
			var creativeElement:XML = SAXMLLib.findFirstInstanceInSiblingsAndChildren(element, "Creative");
			ad.creative = parseCreativeXML(creativeElement);
			
			return ad;
		}
		
		// parse creative ad
		public function parseCreativeXML(element: XML): SAVASTCreative {
			var isLinear:Boolean = SAXMLLib.checkSiblingsAndChildren(element, "Linear");
			var extensions:Array = ["mp4", "flv", "swf"];
			var types:Array = ["video/mp4", "video/x-flv", "application/x-shockwave-flash"];
			
			if (isLinear) {
				var creative:SAVASTCreative = new SAVASTCreative();
				creative.type = SAVASTCreativeType.Linear;
				creative.id = element.attribute("id");
				creative.sequence = element.attribute("sequence");
				
				// recursevly search for "Duration" element
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "Duration", function(xml: XML): void {
					creative.duration = xml.toString();
				});
				
				// recursevly search for "ClickThrough" element
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "ClickThrough", function(xml: XML): void {
					creative.clickThrough = xml.toString();
				});
				
				// recursevly search for "ClickTracking" elements
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "ClickTracking", function(xml: XML): void {
					creative.ClickTracking.push(xml.toString());
				});
				
				// recursevly search for "CustomClicks" elements
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "CustomClicks", function(xml: XML): void {
					creative.CustomClicks.push(xml.toString());
				});
				
				// recurevly search for "Tracking" elements
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "Tracking", function(xml: XML): void {
					var tracking:SAVASTTracking = new SAVASTTracking();
					tracking.event = xml.attribute("event");
					tracking.URL = xml.toString();
					creative.TrackingEvents.push(tracking);
				});
				
				// and finally recursevly search for "MediaFile" elements
				SAXMLLib.searchSiblingsAndChildrenInterate(element, "MediaFile", function(xml: XML): void {
					var mediaFile:SAVASTMediaFile = new SAVASTMediaFile();
					mediaFile.width = xml.attribute("width");
					mediaFile.height = xml.attribute("height");
					mediaFile.type = xml.attribute("type");
					mediaFile.apiFramework = xml.attribute("apiFramework");
					mediaFile.URL = xml.toString();
					
					var hasExt:Boolean = false, hasType:Boolean = false;
					var extension:String = SAUtils.returnExtension(mediaFile.URL);
					
					for (var i: int = 0; i < extensions.length; i++) {
						if (extension && extension.indexOf(extensions[i]) >= 0) {
							hasExt = true;
							break;
						}
					}
					
					for (var t: int = 0; t < types.length; t++) {
						if (mediaFile.type && mediaFile.type.indexOf(types[t]) >= 0) {
							hasType = true;
							break;
						}
					}
					
					if (hasExt || hasType) {
						creative.MediaFiles.push(mediaFile);
					}
				});
				
				// add the playable media URL
				if (creative.MediaFiles.length > 0) {
					creative.playableMediaURL = creative.MediaFiles[0].URL;
				}
				
				return creative;
			}
			
			return null;
		}
	}
}