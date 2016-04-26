package tv.superawesome.sdk.Loader {
	import tv.superawesome.libvast.SAVASTParser;
	import tv.superawesome.libvast.SAVASTParserInterface;
	import tv.superawesome.sdk.Models.SAAd;
	import tv.superawesome.sdk.Models.SACreativeFormat;
	import tv.superawesome.sdk.Models.SAData;
	
	public class SALoaderExtra implements SAVASTParserInterface {
		
		// internal parser object
		private var parser:SAVASTParser = null;
		
		// ad object
		private var ad:SAAd = null;
		
		// function callback
		private var extraDone:Function = null;
		
		//
		// constructor
		public function SALoaderExtra() {
			// do nothing
		}
		
		//
		// main get-data function
		public function getExtraData(_ad:SAAd, _extraDone:Function): void {
			// get ad
			this.ad = _ad;
			this.extraDone = _extraDone;
			ad.creative.details.data = new SAData();
			
			switch (ad.creative.creativeFormat) {
				case SACreativeFormat.video:{
					parser = new SAVASTParser();
					parser.delegate = this;
					parser.parseVASTURL(ad.creative.details.vast);
					break;
				}
				case SACreativeFormat.image:{
					ad.creative.details.data.imagePath = ad.creative.details.image;
					extraDone(ad);
					break;
				}
				case SACreativeFormat.rich:
				case SACreativeFormat.tag:
				default: {
					extraDone(ad);
					break;
				}
			}
		}
		
		// callback from the parser
		public function didParseVAST(ads: Array): void {
			// set ads
			ad.creative.details.data.vastAds = ads;
			
			// done
			extraDone(ad);
		}
	}
}