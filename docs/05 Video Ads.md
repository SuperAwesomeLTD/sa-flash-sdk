Finally, to add a Video ad, two things are required:

First, change the `Main()` function in `Main.as` to contain the following code:

```
var vp2:Rectangle = new Rectangle(0,60,400,300);
var vad:VideoAd = new VideoAd(vp2, 5740);
addChild(vad);
vad.play();

```

What this does is define a new Rectangle and then create a new `VideoAd` object using the rectangle and a test `5740` PlacementId.

The video ad will only play once the `play()` function is called. 

One more thing, in order for video ads to properly work, the `VideoPlayer.swf` file you downloaded earlier must be present in `/project_root`. If this file is missing, video ads will not work.