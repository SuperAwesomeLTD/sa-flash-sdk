package tv.superawesome.Data.Formatter {
	import tv.superawesome.Data.Models.SACreative;
	import tv.superawesome.Data.Models.SACreativeFormat;
//	import flash.filesystem.File;
//	import flash.filesystem.FileStream;
//	import flash.filesystem.FileMode;
	
	public class SAFormatter {
		
		public static function formatCreativeDataIntoAdHTML(creative: SACreative): String {
			
			switch (creative.format) {
				case SACreativeFormat.image_with_link: {
					return formatCreativeIntoImageHTML(creative);
					break;
				}
				case SACreativeFormat.video: {
					return formatCrativeIntoVideoHTML(creative);
					break;
				}
				case SACreativeFormat.rich_media: {
					return formatCreativeIntoRichMediaHTML(creative);
					break;
				}
				case SACreativeFormat.rich_media_resizing: {
					return formatCreativeIntoRichMediaResizingHTML(creative);
					break;
				}
				case SACreativeFormat.swf: {
					return formatCreativeIntoSWFHTML(creative);
					break;
				}
				case SACreativeFormat.tag: {
					return formatCreativeIntoTagHTML(creative);
					break;
				}
				default: {
					break;
				}
			}
			
			return null;
		}
		
		private static function readFileContents(path: String): String {
//			var file: File = File.userDirectory.resolvePath(path);
//			var fileStream:FileStream = new FileStream();
//			fileStream.open(file, FileMode.READ);
//			var str:String = fileStream.readUTFBytes(file.size);
//			fileStream.close();
			return "";
		}
		
		private static function formatCreativeIntoImageHTML(creative: SACreative): String {
			var template: String = readFileContents("/Users/gabriel.coman/Workspace/sa-adobeair-sdk/tv/resources/displayImage.html");
			var value: String = creative.details.image;
			var click: String = creative.clickURL;
			template = template.replace("imageURL", value);
			template = template.replace("hrefURL", click);
			return template;
		}
		
		private static function formatCrativeIntoVideoHTML(creative: SACreative): String {
			var template: String = readFileContents("/Users/gabriel.coman/Workspace/sa-adobeair-sdk/tv/resources/displayVideo.html");
			var value: String = creative.details.video;
			var click: String = creative.clickURL;
			template = template.replace("videoURL", value);
			template = template.replace("hrefURL", click);
			return template;
		}
		
		private static function formatCreativeIntoRichMediaHTML(creative: SACreative): String {
			var template: String = readFileContents("/Users/gabriel.coman/Workspace/sa-adobeair-sdk/tv/resources/displayRichMedia.html");
			var value: String = creative.details.url;
			template = template.replace("richMediaURL", value);
			return template;
		}
		
		private static function formatCreativeIntoRichMediaResizingHTML(creative: SACreative): String {
			var template: String = readFileContents("/Users/gabriel.coman/Workspace/sa-adobeair-sdk/tv/resources/displayRichMedia.html");
			var value: String = creative.details.url;
			template = template.replace("richMediaURL", value);
			return template;
		}
		
		private static function formatCreativeIntoSWFHTML(creative: SACreative): String {
			return "";
		}
		
		private static function formatCreativeIntoTagHTML(creative: SACreative): String {
			var template: String = readFileContents("/Users/gabriel.coman/Workspace/sa-adobeair-sdk/tv/resources/displayRichMedia.html");
			var value: String = creative.details.tag;
			value = getSubString("src=\"","\"",value);
			template = template.replace("richMediaURL", value);
			return template;
		}
		
		// aux function
		private static function getSubString(start:String, end:String, fullString:String):String {
			var startIndex:Number = fullString.indexOf(start) + start.length;
			var endIndex:Number = fullString.indexOf(end) - 1;
			return fullString.substring(startIndex, endIndex);
		}
	}	
}