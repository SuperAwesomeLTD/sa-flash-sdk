Additionally, if your `Main` class implements functions from the `SAVideoProtocol`, you can catch events like video start or end.

As usual, you need to change your `Main` class:

```
public class Main extends MovieClip implements SALoaderProtocol, SAViewProtocol, SAVideoAdProtocol {
	
	// triggered when a video has started playing
	public function videoStarted(placementId: int): void {

	}

	// triggered when a video has played 1/4 of its length
	public function videoReachedFirstQuartile(placementId:int): void {
	
	}
	
	// triggered when a video has played 1/2 of its length
	public function videoReachedMidpoint(placementId:int): void {
	
	}
	
	// triggered when a video has played 3/4 of its length
	public function videoReachedThirdQuartile(placementId: int): void {
	
	}

	// triggered when a video has ended playing
	public function videoEnded(placementId:int): void {

	}
}
```

And just as before, any Video Ads in your app must set their `videoDelegate` object to `Main`, as class that implements the SAVideoAdProtocol interface.

```
var videoAd: SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 480, 320), 5740);
videoAd.videoDelegate = this; // where this is Main
videoAd.playInstant();
addChild(videoAd);

```