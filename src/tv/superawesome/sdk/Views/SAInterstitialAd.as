//
//  SAInterstitialAd.h
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import tv.superawesome.sdk.Views.SABannerAd;
	import tv.superawesome.sdk.Views.SAView;
	
	// Class that represents an interstitial ad
	// it's both a descendant of SAView as well as a composer class
	// that contains a SABannerAd that's displayed over an 
	// interstitial fullscreen sprite
	public class SAInterstitialAd extends SAView{
		// private vars
		private var background: Sprite;
		private var close: Sprite;
		private var banner: SABannerAd;
		
		// constructor
		public function SAInterstitialAd() {
			super(new Rectangle(0,0,0,0));
		}
		
		// custom override of the play function
		public override function play(): void {
			
			// display
			if (stage) delayedDisplay();
			else addEventListener(Event.ADDED_TO_STAGE, delayedDisplay);
		}
		
		private function delayedDisplay(e:Event = null): void  {
			
			// setup the frame
			super.frame = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// load external resources
			[Embed(source = '../../../../resources/bg.png')] var BgIconClass:Class;
			var bmp2:Bitmap = new BgIconClass();
			
			[Embed(source = '../../../../resources/close.png')] var CancelIconClass:Class;
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
			
			// create the banner ad
			var tW: Number = super.frame.width * 0.85;
			var tH: Number = super.frame.height * 0.85;
			var tX: Number = ( super.frame.width - tW ) / 2;
			var tY: Number = ( super.frame.height - tH) / 2;
			banner = new SABannerAd(new Rectangle(tX, tY, tW, tH));
			banner.setAd(this.ad);
			banner.adDelegate = this.adDelegate;
			this.addChild(banner);
			banner.play();
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