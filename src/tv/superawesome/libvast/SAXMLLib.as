package tv.superawesome.libvast {
	public class SAXMLLib {
		//
		// private recursive exploratory function
		// will search for an element named "name" in all of the siblings and children of a XML tag
		// @param txml - the XML node
		// @param name - the name of the XML node to search for
		// @param elementsArray - an array of elements passed as reference, into which corresponding
		// XML elements are being added
		private static function searchSiblingsAndChildrenIntoArray(txml: XML, name: String, elementsArray: Array): void {
			
			if (txml.hasOwnProperty(name) == true) {
				var children: XMLList = txml.child(name);
				for (var i: int = 0; i < children.length(); i++) {
					elementsArray.push(children[i]);
				}
				return;
			} else {
				for each(var child: XML in txml.children()) {
					searchSiblingsAndChildrenIntoArray(child, name, elementsArray);
				}
			}
		}
		
		//
		// shorthand function of the above that doesn't require the user to always declare an array
		private static function searchSiblingsAndChildren(txml: XML, name: String) : Array {
			var elements: Array = new Array();
			searchSiblingsAndChildrenIntoArray(txml, name, elements);
			return elements;
		}
		
		// iterator function
		public static function searchSiblingsAndChildrenInterate(txml: XML, name: String, iterator: Function): void {
			var elements: Array = searchSiblingsAndChildren(txml, name);
			for (var i: int = 0; i < elements.length; i++) {
				iterator(elements[i]);
			}
		}
		
		// function that just checks to see if I can find the value that's defined by "name", and
		// returns true; else returns false
		public static function checkSiblingsAndChildren(txml: XML, name: String): Boolean {
			var elements: Array = searchSiblingsAndChildren(txml, name);
			if (elements.length > 0) return true;
			return false;
		}
		
		//
		// function that searches for the first element that matches the "name" parameter
		public static function findFirstInstanceInSiblingsAndChildren(txml: XML, name: String): XML {
			var elements: Array = searchSiblingsAndChildren(txml, name);
			if (elements.length > 0) return elements[0];
			return null;
		}
	}
}