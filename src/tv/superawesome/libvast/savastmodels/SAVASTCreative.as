package tv.superawesome.libvast.savastmodels {
	public class SAVASTCreative {
		
		public var type: int = SAVASTCreativeType.Invalid;
		
		public function SAVASTCreative(){
		}
		
		public function print(): void {
			var tp: String = null;
			if (type == SAVASTCreativeType.Linear) tp = "Linear";
			else if (type == SAVASTCreativeType.NonLinear) tp = "NonLinear";
			else if (type == SAVASTCreativeType.CompanionAds) tp = "CompanionAds";
			trace("\tCreative " + tp);
		}
		
		public function sumCreative(creative: *): void {
			// do nothing
		}
	}
}