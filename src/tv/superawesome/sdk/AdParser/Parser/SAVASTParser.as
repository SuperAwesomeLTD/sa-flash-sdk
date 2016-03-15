//
//  SAVASTParser.h
//  tv.superawesome.Data.Parser
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/10/2015.
//
//
package tv.superawesome.sdk.AdParser.Parser {
	
	// imports needed
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	//
	// a simple VAST Parser - 'till I can switch this whole code to iOS / Android native
	public class SAVASTParser {
		
		// private data
		private var vastData: SAVASTData;
		
		// function pointer to the return callback
		private var returnFunc: Function;
		
		// reference vars
		private var isWrapper: Boolean = false;
		private var VASTAdTagURI: String = null;
		private var start: Array;
		
		// empty constructor
		public function SAVASTParser() {
			vastData = new SAVASTData();
			start = new Array();
		}
		
		// @brief: this function starts the vast parsing
		// @param - vastURL: the URL where the VAST XML is located
		// @param - onComplete: function pointer to the callback - that is saved locally
		public function simpleVASTParse(vastURL: String, onComplete: Function): void {
			
			// start async loading of data
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.load(new URLRequest (vastURL));
			xmlLoader.addEventListener(Event.COMPLETE, function (e:Event): void {
				var xml: XML = new XML(e.target.data);
				isWrapper = false;
				
				// get data from XML
				searchRecursevlyForWrapper(xml);
				searchRecursevlyForClickThrough(xml);
				searchRecursevlyForClickTracking(xml);
				searchRecursevlyForImpressions(xml);
				searchRecursevlyForComplete(xml);
				searchRecursevlyForMedia(xml);
				if (vastData.mediaFiles.length > 0) {
					vastData.playableMediaURL = vastData.mediaFiles[0];
				}
				
				// recursively search wrapper data
				if (isWrapper == true) {
					searchRecursevlyForVASTAdTagURI(xml);
					simpleVASTParse(VASTAdTagURI, onComplete);
				} 
				// else end this
				else {
					onComplete(vastData);
				}
			});
		}
		
		////////////////////////////////////////////////
		// Rescursive search functions
		////////////////////////////////////////////////
		
		private function searchRecursevlyForWrapper(txml: XML): void {
			if (txml.hasOwnProperty('Wrapper') == true) {
				this.isWrapper = true;
				return;
			} else {
				for each(var child: XML in txml.children()) {
					searchRecursevlyForWrapper(child);
				}
			}
		}
		
		private function searchRecursevlyForClickThrough(txml: XML): void {
			if (txml.hasOwnProperty('ClickThrough') == true){
				this.vastData.clickThroughURL = txml.ClickThrough;
				return;
			} 
			else {
				for each (var child: XML in txml.children()) {
					searchRecursevlyForClickThrough(child);
				}
			}
		}
		
		private function searchRecursevlyForClickTracking(txml: XML): void {
			if (txml.hasOwnProperty('ClickTracking') == true){
				var list: XMLList = txml.ClickTracking;
				for (var i:int = 0; i < list.length(); i++){
					this.vastData.clickTracking.push(list[i]);
				}
				return;
			} 
			else {
				for each (var child: XML in txml.children()) {
					searchRecursevlyForClickTracking(child);
				}
			}
		}
		
		private function searchRecursevlyForImpressions(txml: XML): void {
			if (txml.hasOwnProperty('Impression') == true){
				var list: XMLList = txml.Impression;
				for (var i:int = 0; i < list.length(); i++){
					this.vastData.impressions.push(list[i]);
				}
				return;
			} else {
				for each (var child: XML in txml.children()) {
					searchRecursevlyForImpressions(child);
				}
			}
		}
		
		private function searchRecursevlyForComplete(txml: XML): void {
			if (txml.hasOwnProperty('Tracking') == true){
				var list: XMLList = txml.Tracking.(@event == 'complete');
				for (var i:int = 0; i < list.length(); i++){
					this.vastData.completedURL.push(list[i]);
				}
				return;
			} else {
				for each (var child: XML in txml.children()) {
					searchRecursevlyForComplete(child);
				}
			}
		}
		
		private function searchRecursevlyForMedia(txml: XML): void {
			if (txml.hasOwnProperty('MediaFile') == true){
				var media: XMLList = txml.MediaFile;
				for (var i: int = 0; i < media.length(); i++) {
					if (media[i].indexOf(".mp4") != -1) {
						this.vastData.mediaFiles.push(media[i]);
					}
				}
				return;
			} else {
				for each(var child: XML in txml.children()){
					searchRecursevlyForMedia(child);
				}
			}
		}
		
		private function searchRecursevlyForVASTAdTagURI(txml: XML): void {
			if (txml.hasOwnProperty('VASTAdTagURI') == true){
				this.VASTAdTagURI = txml.VASTAdTagURI;
				return;
			} 
			else {
				for each (var child: XML in txml.children()) {
					searchRecursevlyForVASTAdTagURI(child);
				}
			}
		}
	}
}