package tv.superawesome.libvast.savastmodels {
	import tv.superawesome.sdk.AdParser.Models.SACreative;

	public class SAVASTAd {
		
		public var type: int = SAAdType.Invalid;
		public var id: String = null;
		public var sequence: String = null;
		public var Errors: Array;
		public var Impressions: Array;
		public var isImpressionSent:Boolean = false;
		public var Creatives: Array;
		
		public function SAVASTAd() {
			Errors = new Array();
			Impressions = new Array();
			Creatives = new Array();
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
			for (var j: int = 0; j < Creatives.length; j++) {
				var cr:SAVASTCreative = Creatives[j];
				cr.print();
			}
		}
		
		public function sumAd(ad:SAVASTAd): void {
			this.id = ad.id;
			this.sequence = ad.sequence;
			this.Errors = this.Errors.concat(ad.Errors);
			this.Impressions = this.Impressions.concat(ad.Impressions);
			for (var p:int = 0; p < this.Creatives.length; p++) {
				var creative1:SAVASTCreative = this.Creatives[p];
				for (var u:int = 0; u < ad.Creatives.length; u++) {
					var creative2:SAVASTCreative = ad.Creatives[u];
					creative1.sumCreative(creative2);
				}
			}
		}
	}
}