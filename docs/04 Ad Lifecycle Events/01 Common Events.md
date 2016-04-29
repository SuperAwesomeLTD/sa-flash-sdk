Using the same delegate pattern all ads can serve additional events than can be caught and acted upon.

First you'll need to include two interfaces in your source file:

```
import tv.superawesome.sdk.Views.SAVideoAdInterface;
import tv.superawesome.sdk.Views.SAAdInterface;

```

Then your `Main` class must implement the `SAAdInterface` interface:

```

// this function will be called when a certain Ad has been shown on the screen
public function adWasShown(placementId: int): void {
	
}

// this function will be called when a certain Ad has, for some reason,
// failed to show
public function adFailedToShow(placementId: int): void {
	
}

// this function will be called when an Interstitial or Fullscreen Video Ad
// has been close
public function adWasClosed(placementId: int): void {
	
}

// this function will be called when a user clicks or taps on an Ad and 
// follows the Ads associated URL
public function adWasClicked(placementId: int): void {
	
}

// this function gets called when the ad data served to the display ad
// has an incorrect format (e.g. trying to load video ad data into a banner ad)
public function adHasIncorrectPlacement(placementId: int): void {
	
}

```

Finally, to complete the code, all ads must assign their `delegate` object to `Main`. This means that when an ad launches an adWasShown or adWasClosed event, Main will respond with the functions implemented above.

```
var bannerad: SABannerAd = new SABannerAD(new Rectangle(0, 0, 320, 50), 5687);
bannerad.adDelegate = this; // where this is Main

```