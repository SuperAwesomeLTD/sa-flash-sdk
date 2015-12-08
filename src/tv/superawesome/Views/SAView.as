//
//  SAView.h
//  tv.superawesome.Views
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

package tv.superawesome.Views{
	
	// imports needed
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import tv.superawesome.Data.Models.SAAd;
	import tv.superawesome.Data.Sender.SASender;
	import tv.superawesome.Views.Protocols.SAAdProtocol;
	
	//
	// @brief: Base class for all other specific ad classes
	public class SAView extends Sprite {
		// delegate reference
		public var adDelegate: SAAdProtocol;
		
		// private variables
		protected var ad: SAAd = null;
		
		// frame and aux variables
		protected var frame: Rectangle;
		
		// public vars
		public var isParentalGateEnabled: Boolean;
		public var refreshPeriod: int;
		
		// constructor
		public function SAView(frame: Rectangle) {
			this.frame = frame;
		}		
		
		public function setAd(_ad: SAAd): void {
			this.ad = _ad;
		}
		
		// public play functions
		public function play(): void {
			// do nothing
		}
		
		// what happens when ad loads with success
		protected function success(): void {
			SASender.sendEventToURL(ad.creative.viewableImpressionURL);
			
			if (this.adDelegate != null) {
				this.adDelegate.adWasShown(this.ad.placementId);
			}
		}
		
		// what happens when ad loads with error
		protected function error(e: ErrorEvent = null): void {
			
			if (this.adDelegate != null) {
				this.adDelegate.adFailedToShow(this.ad.placementId);
			}
		}
		
		// in Flash the gotoURL function is simple because it can't
		// render nasty rich media or 3rd party tags
		protected function goToURL(e: MouseEvent = null): void {
			
			if (this.adDelegate != null) {
				this.adDelegate.adWasClicked(this.ad.placementId);
			}
			
			trace("\t[OK] Click:\t" + this.ad.creative.clickURL);
			var clickURL: URLRequest = new URLRequest(this.ad.creative.clickURL);
			navigateToURL(clickURL, "_blank");
		}
	}
}

