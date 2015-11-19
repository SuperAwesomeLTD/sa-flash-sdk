﻿// ActionScript file

package tv.superawesome.Views{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import tv.superawesome.Data.Models.SAAd;
	import tv.superawesome.Data.Sender.SASender;
	import tv.superawesome.Views.SAAdProtocol;
	
	public class SAView extends Sprite {
		// delegate
		public var delegate: SAAdProtocol;
		
		// private variables
		protected var ad: SAAd = null;
		
		// frame and aux variables
		protected var frame: Rectangle;
		
		// public vars
		public var isParentalGateEnabled: Boolean;
		public var refreshPeriod: int;
		public var maintainsAspectRatio: Boolean = true;
		
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
		
		protected function arrangeAdInFrame(frame: Rectangle): Rectangle {
			
			var newW: Number = frame.width;
			var newH: Number = frame.height;
			var oldW: Number = ad.creative.details.width;
			var oldH: Number = ad.creative.details.height;
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
		
		protected function success(): void {
			trace("success");
			SASender.sendEventToURL(ad.creative.viewableImpressionURL);
			
			if (this.delegate != null) {
				this.delegate.adWasShown(this.ad.placementId);
			}
		}
		
		protected function error(): void {
			
			if (this.delegate != null) {
				this.delegate.adFailedToShow(this.ad.placementId);
			}
		}
		
		protected function goToURL(e: MouseEvent = null): void {
			
			if (this.delegate != null) {
				this.delegate.adWasClicked(this.ad.placementId);
			}
			
			trace("\t[OK] Click:\t" + this.ad.creative.clickURL);
			var clickURL: URLRequest = new URLRequest(this.ad.creative.clickURL);
			navigateToURL(clickURL, "_blank");
		}
	}
}

