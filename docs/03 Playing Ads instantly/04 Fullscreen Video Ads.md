Finally, to add a Fullscreen Video Ad change the `Main()` function in `Main.as` to contain the following code:

```
var vad: SAFullscreenVideoAd = new SAFullscreenVideoAd(5740);
addChild(vad);
vad.playInstant();

```

It is similar to the Interstitial Ad in that it does not need a rectangle defined, because it will cover the whole screen (and try to keep the correct video aspect ratio).

Naturally, the ad will only play once the `playInstant()` function is called. 
