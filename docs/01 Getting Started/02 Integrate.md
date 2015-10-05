### Download the necessary files

The Flash SDK is compiled into a .swc file that you can download from here [SuperAwesome.swc](https://github.com/SuperAwesomeLTD/sa-flash-sdk/raw/master/bin/SuperAwesome.swc).
This will allow you to add Banner and Interstitial Ads to your project.

To be able to add Video Ads, you have to also download [VideoPlayer.swf](https://github.com/SuperAwesomeLTD/sa-flash-sdk/raw/master/bin/VideoPlayer.swf).

Once you've downloaded these two files, you need to add them to your project.


### Setup the Adobe Flash CC Environment

Create a new Action Script 3.0 project in Adobe Flash CC (or use your existing one). This can be situated anywhere on your hard drive, such as:

  * C:/Workspace/MyFlashProject/
  * /Users/myuser/Workspace/MyFlashProject/

We'll refer to this location from now on simply as `/project_root`. There should be two important files in this folder:
  * `MyFlashProject.fla` - a file created by the Flash CC Environment
  * `Main.as` - or a similary named file, that acts as the main class of the Flash application.

![](img/flash_main.png "The link between .fla file and .as main class")

### Adding the SDK

To add the SDK to the project, simply copy the two files you just downloaded, `SuperAwesome.swc` and `VideoPlayer.swf`, into `/project_root`. 
Then you'll need to setup library paths, as follows:

Go to the File -> Publish Settings menu. A pop-up will appear with different settings. Press on the `Action Script 3 Settings` button.

![](img/flash_settings_1.png "Press on the Action Script 3 Settings button")

There, in the `Library path` tab, add the relative or absolute path to where you have saved the `SuperAwesome.swc` file (in this case, the `/project_root` folder). In this way, your whole project will have access to the SDK.

![](img/flash_settings_2.png "Setup the path to the library")

Press OK and then make sure that in the `Publish Settings` menu the `Local playback security` option is set to `Access network only`.

![](img/flash_settings_3.png "Set Local playback security to Access network only")


