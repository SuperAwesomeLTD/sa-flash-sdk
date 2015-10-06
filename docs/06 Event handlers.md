Each type of ad (banner, interstitial or video) sends some default messages that you can intercept:
  * ad was loaded
  * ad has failed loading
  * ad was closed
  * ad was empty

To intercept them, each Ad class offers three identical functions that allow you to define your own behaviour for what happens when an ad fails, succesfully loads, is closed or is empty (server returned empty JSON).

`onAdLoad` is triggered when an ad has finally loaded. It takes another function as a parameter, which can be specified inline or in another part of the file. 

```
ad.onAdLoad(function(){
	trace("ad loaded");
});

```

`onAdFail` is triggered when an ad has failed loading. It takes another function as a parameter, which can be specified inline or in another part of the file.

```
ad.onAdFail(function(){
	trace("ad failed");
});

```

`onAdClose` is triggered when an ad is closed. For the moment it applies only to interstitial ads. Banner and Video ads do not trigger this event. The function takes another function as parameter.

```
ad.onAdClose(function() {
	trace("ad closed");
});

```

`onAdEmpty` is triggered when an ad is loaded OK but the server returns an empty JSON. This might be because the placement is invalid or because there is no campaign data associated with the placement. The function takes another function as parameter.

```
ad.onAdEmpty(function(){
	trace("ad empty");
});
```
