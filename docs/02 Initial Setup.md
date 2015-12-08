To begin using the SDK, you need to change some parts of your `Main.as` file, in order to import the tv.superawesome. package and setup some global variables:

```
package  {
	// imports MovieClip (standard Flash package)
	import flash.display.MovieClip;

	// import all classes from the SuperAwesome package
	import tv.superawesome.*;
	
	// main class - always extends from MovieClip
	public class Main extends MovieClip {
		
		
		public function Main() {
			// Configures SuperAwesome SDK to production mode
			SuperAwesome.getInstance().setConfigurationProduction();

			// enables or disabled test mode
			SuperAwesome.getInstance().enableTestMode();
		}
	}
	
}
```

The SuperAwesome SDK can be setup in two ways: Production and Staging, by using:

```
SuperAwesome.getInstance().setConfigurationProduction();
SuperAwesome.getInstance().setConfigurationStaging();

```

And you can also enable or disable test mode globally, by using:

```
SuperAwesome.getInstance().enableTestMode();
SuperAwesome.getInstance().disableTestMode();

```

By default, the environment is set to Production Mode and Test Mode disabled.




