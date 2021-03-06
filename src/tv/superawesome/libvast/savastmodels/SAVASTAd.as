package tv.superawesome.libvast.savastmodels {
	
	public class SAVASTAd {
		
		public var type: int = SAAdType.Invalid;
		public var id: String = null;
		public var sequence: String = null;
		public var redirectUri: String = null;
		public var Errors: Array;
		public var Impressions: Array;
		public var isImpressionSent:Boolean = false;
		public var creative: SAVASTCreative = null;
		
		public function SAVASTAd() {
			Errors = new Array();
			Impressions = new Array();
		}
		
		public function print(): void {
			var s:String = (sequence ? sequence : "0");
			trace("SAVASTAd " + type + " " + s + " [" + id + "]");
			for (var i: int = 0; i < Errors.length; i++) {
				trace("Error => " + Errors[i]);
			}
			trace("Impression sent => " + isImpressionSent);
			for (var t: int = 0; t < Impressions.length; t++) {
				trace("Impression => " + Impressions[t]);
			}
			creative.print();
		}
		
		public function sumAd(ad:SAVASTAd): void {
			this.id = ad.id;
			this.sequence = ad.sequence;
			this.Errors = this.Errors.concat(ad.Errors);
			this.Impressions = this.Impressions.concat(ad.Impressions);
			this.creative.sumCreative(ad.creative);
			
//			for (var p:int = 0; p < this.Creatives.length; p++) {
//				var creative1:SAVASTCreative = this.Creatives[p];
//				for (var u:int = 0; u < ad.Creatives.length; u++) {
//					var creative2:SAVASTCreative = ad.Creatives[u];
//					creative1.sumCreative(creative2);
//				}
//			}
		}
	}
}