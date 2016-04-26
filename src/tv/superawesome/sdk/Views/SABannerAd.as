//
//  SABannerAd.h
//  tv.superawesome.Views
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

package tv.superawesome.sdk.Views {
	
	// imports for this class
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import tv.superawesome.libutils.SAUtils;
	import tv.superawesome.sdk.Models.SACreativeFormat;
	import tv.superawesome.sdk.Views.SAView;
	
	// descendant of SAView that is used to
	// represent image data - banner ads, MPU, etc
	public class SABannerAd extends SAView {
		// the loader
		private var imgLoader: Loader = new Loader();
		private var background: Sprite;
		
		// constructor
		public function SABannerAd(frame: Rectangle) {
			super(frame);
		}
		
		// local implementation of the play function
		public override function play(): void {	
			// check for incorrect format
			if (ad.creative.format != SACreativeFormat.image) {
				if (this.adDelegate != null) {
					this.adDelegate.adHasIncorrectPlacement(ad.placementId);
				}
				return;
			}
			
			if (this.stage != null) delayedDisplay();
			else this.addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void {
			
			// create background and static elements
			[Embed(source = '../../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = super.frame.x;
			background.y = super.frame.y;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			// laod the image async
			var imgURLRequest: URLRequest = new URLRequest(super.ad.creative.details.image);
			
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error);
			imgLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			
			imgLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
			imgLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			imgLoader.addEventListener(MouseEvent.CLICK, goToURL);
			
			try {
				imgLoader.load(imgURLRequest, loaderContext);
			} catch (e: *) {
				error();
			}
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// calc scaling
			var newR: Rectangle = super.frame;
			
			newR = SAUtils.arrangeAdInNewFrame(
				super.frame, 
				new Rectangle(0, 0, ad.creative.details.width, ad.creative.details.height)
			);
			newR.x += super.frame.x;
			newR.y += super.frame.y;
			
			// position the image
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			
			// add the child
			this.addChild(imgLoader);
			
			// remove listener
			e.target.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			// call to success
			success();
		}
	}
}