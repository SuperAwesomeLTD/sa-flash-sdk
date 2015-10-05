Creating interstitial ads is similar.

Just add the following lines of code to your `Main()` function:

```
var iad:InterstitialAd = new InterstitialAd(5692);
addChild(iad);
iad.play();

```

Notice that an interstitial ad does not need specifying a rectanlge, since it automatically covers the whole screen, as a popup. Again, since test mode is enabled, we can use the `5692` test placement, but it's advised to use the one received got from the Dashboard.

Also notice the interstitial ad has a special `play()` function. Only when this function is called does the ad actually display. 