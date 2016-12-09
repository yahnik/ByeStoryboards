# ByeStoryboards
The current default XCode project comes bundled with a file, `Main.storyboard`, to be used for the main UI. If you don't want to use storyboards for your project, there are a few necessary steps to rip out the storyboard and set up the `UIWindow` programmatically. This script automates as much of that process as possible.

## Usage
`ruby bye_storyboards.rb <project root>`

#####Example output:
```
Dan@[~/code/ByeStoryboards]$ ruby bye_storyboards.rb ../TextFieldFoolin
Removing default storyboard from TextFieldFoolin...
==> Cleaning plist file: ../TextFieldFoolin/TextFieldFoolin/Info.plist
	Removing line: 	<key>UIMainStoryboardFile</key>
	Removing line: 	<string>Main</string>
==> Opening project file: ../TextFieldFoolin/TextFieldFoolin.xcodeproj
	Removing Main.storyboard from project

Done! Drop something like this in AppDelegate.m didFinishLaunchingWithOptions:

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UIViewController alloc] init];
```

## TODOs
- Clear out LaunchScreen.storyboard and replace with LaunchScreen.xib, add entry to Info.plist
- Manually add window initialization to the app delegate
