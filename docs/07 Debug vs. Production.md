### Debug

At this moment your `/project_root` folder should contain at least the following files:
  * `MyFlashProject.fla`
  * `Main.as`
  * `MyFlashProject.swf`
  * `SuperAwesome.swc`
  * `VideoPlayer.swf`

To test the ads, simply press on the Control -> Test menu in Flash CC.

### Deployment

There are no special requirements with AwesomeAds SDK when deploying a .swf project on a webserver. You simply package your project as a .swf file (such as `MyFlashProject.swf`) and place it in the desired server folder in order to be served. No need to copy the `SuperAwesome.swc` file, it will come bundled with the .swf file.

However, at this moment, you will need to copy the `VideoPlayer.swf` file in the server folder.