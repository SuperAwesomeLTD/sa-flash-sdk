//
//  SAInterstitialAd.h
//  tv.superawesome.Views
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

package tv.superawesome.Views {

	// imports for this class
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import tv.superawesome.Aux.SAAux;
	import tv.superawesome.Data.Models.SACreativeFormat;
	import tv.superawesome.Views.SAView;
	
	// descendant of SAView that is used to
	// represent image data - banner ads, MPU, etc
	public class SAInterstitialAd extends SAView{
		// private vars
		private var imgLoader: Loader = new Loader();
		private var background: Sprite;
		private var close: Sprite;
		
		// constructor
		public function SAInterstitialAd() {
			super(new Rectangle(0,0,0,0));
		}
		
		// custom override of the play function
		public override function play(): void {
			
			// check for incorrect format
			if (ad.creative.format != SACreativeFormat.image) {
				if (this.adDelegate != null) {
					this.adDelegate.adHasIncorrectPlacement(ad.placementId);
				}
				return;
			}
			
			// display
			if (stage) delayedDisplay();
			else addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void  {
			
			// setup the frame
			super.frame = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// load external resources
			[Embed(source = '../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			[Embed(source = '../../../resources/close.png')] var CancelIconClass:Class;
			var bmp: Bitmap = new CancelIconClass();
			
			background = new Sprite();
			background.addChild(bmp2);
			background.x = 0;
			background.y = 0;
			background.width = super.frame.width;
			background.height = super.frame.height;
			this.addChild(background);
			
			close = new Sprite();
			close.addChild(bmp);
			close.x = super.frame.width-35;
			close.y = 5;
			close.width = 30;
			close.height = 30;
			close.addEventListener(MouseEvent.CLICK, closeAction);
			this.addChild(close);
			
			// send the request
			var imgURLRequest: URLRequest = new URLRequest(super.ad.creative.details.image);
			var loaderContext: LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = false;
			imgLoader.load(imgURLRequest, loaderContext);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
			imgLoader.addEventListener(MouseEvent.CLICK, goToURL);
		}
		
		// what happens when an image is loaded
		private function onImageLoaded(e: Event): void {
			// calc scaling
			var tW: Number = super.frame.width * 0.85;
			var tH: Number = super.frame.height * 0.85;
			var tX: Number = ( super.frame.width - tW ) / 2;
			var tY: Number = ( super.frame.height - tH) / 2;
			var newR: Rectangle = SAAux.arrangeAdInNewFrame(
				new Rectangle(tX, tY, tW, tH),
				new Rectangle(0, 0, ad.creative.details.width, ad.creative.details.height)
			);
			newR.x += tX;
			newR.y += tY;
			
			// banner
			imgLoader.x = newR.x;
			imgLoader.y = newR.y;
			imgLoader.width = newR.width;
			imgLoader.height = newR.height;
			this.addChild(imgLoader);
			
			// remove listener
			e.target.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			// call to success
			success();
		}
		
		private function closeAction(event: MouseEvent): void {
			// call remove child
			this.parent.removeChild(this);
			
			// call delegate
			if (super.adDelegate != null) {
				super.adDelegate.adWasClosed(ad.placementId);
			}
		}
	}
}