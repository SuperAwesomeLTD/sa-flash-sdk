Additionally, if your `Main` class implements functions from the `SAVideoInterface`, you can catch events like video start or end.

As usual, you need to change your `Main` class:

```
public class Main extends MovieClip implements SALoaderInterface, SAAdInterface, SAVideoAdInterface {
	
	// fired when an ad has started
	public function adStarted(placementId: int): void {

	}	
	
	// fired when a video ad has started
	public function videoStarted(placementId: int): void {

	}
		
	// fired when a video ad has reached 1/4 of total duration
	public function videoReachedFirstQuartile(placementId: int): void {

	}
		
	// fired when a video ad has reached 1/2 of total duration
	public function videoReachedMidpoint(placementId: int): void {

	}
		
	// fired when a video ad has reached 3/4 of total duration
	public function videoReachedThirdQuartile(placementId: int): void {

	}
		
	// fired when a video ad has ended
	public function videoEnded(placementId: int):void {

	}
		
	// fired when an ad has ended
	public function adEnded(placementId: int):void {

	}
		
	// fired when all ads have ended
	public function allAdsEnded(placementId: int):void {

	}
}
```

And just as before, any Video Ads in your app must set their `videoDelegate` object to `Main`, as class that implements the SAVideoAdInterface interface.

```
var videoAd: SAVideoAd = new SAVideoAd(new Rectangle(0, 0, 480, 320), 5740);
videoAd.videoDelegate = this; // where this is Main
videoAd.playInstant();
addChild(videoAd);

```