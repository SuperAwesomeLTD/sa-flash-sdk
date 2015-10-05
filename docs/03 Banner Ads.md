Once that is done, you can create a test banner by adding the following lines to the `Main()` function: 

```
var vp:Rectangle = new Rectangle(0,0,320,50);
var ad:BannerAd = new BannerAd(vp, 5687);
addChild(ad);

```

You first create a rectangle that should be the size of the Ad you specified in the dashboard. Then create a new `BannerAd` object, using the rectangle and a PlacementId. 
Since we enabled test mode in the previous section, it is alright to use `5687` as a PlacementId, but you should use the one obtained in the Dashboard for real ads.