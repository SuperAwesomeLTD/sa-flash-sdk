// ActionScript file

package tv.superawesome.Views {
	public interface SAVideoAdProtocol {
		function videoStarted(placementId: int): void;
		function videoEnded(placementId:int): void;
		function videoReachedFirstQuartile(placementId:int): void;
		function videoReachedMidpoint(placementId:int): void;
		function videoReachedThirdQuartile(placementId: int): void;
		function videoSkipped(placementId: int): void;
	}
}