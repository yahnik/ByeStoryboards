# ByeStoryboards
The current default XCode project comes bundled with a file, `Main.storyboard`, to be used for the main UI. If you don't want to use storyboards for your project, there are a few necessary steps to rip out the storyboard and set up the `UIWindow` programmatically. This script automates as much of that process as possible.

Note that this script assumes you haven't changed the structure or file names in your new XCode project.

Requires https://github.com/CocoaPods/Xcodeproj. Install by running `$ [sudo] gem install xcodeproj`

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
==> Updating app delegate: ../TextFieldFoolin/TextFieldFoolin/AppDelegate.m

Done!
```

#####Resulting Diff
```
Dan@[~/code/TextFieldFoolin]$ git diff
diff --git a/TextFieldFoolin.xcodeproj/project.pbxproj b/TextFieldFoolin.xcodeproj/project.pbxproj
index 6ce02f7..9828b5d 100644
--- a/TextFieldFoolin.xcodeproj/project.pbxproj
+++ b/TextFieldFoolin.xcodeproj/project.pbxproj
@@ -10,7 +10,6 @@
                3784535F1DFA882800FADCEE /* main.m in Sources */ = {isa = PBXBuildFile; fileRef = 3784535E1DFA882800FADCEE /* main.m */; };
                378453621DFA882800FADCEE /* AppDelegate.m in Sources */ = {isa = PBXBuildFile; fileRef = 378453611DFA882800FADCEE /* AppDelegate.m */; };
                378453651DFA882800FADCEE /* ViewController.m in Sources */ = {isa = PBXBuildFile; fileRef = 378453641DFA882800FADCEE /* ViewController.m */; };
-               378453681DFA882800FADCEE /* Main.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = 378453661DFA882800FADCEE /* Main.storyboard */; };
                3784536A1DFA882800FADCEE /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 378453691DFA882800FADCEE /* Assets.xcassets */; };
                3784536D1DFA882800FADCEE /* LaunchScreen.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = 3784536B1DFA882800FADCEE /* LaunchScreen.storyboard */; };
                378453781DFA882800FADCEE /* TextFieldFoolinTests.m in Sources */ = {isa = PBXBuildFile; fileRef = 378453771DFA882800FADCEE /* TextFieldFoolinTests.m */; };
@@ -251,7 +250,6 @@
                        files = (
                                3784536D1DFA882800FADCEE /* LaunchScreen.storyboard in Resources */,
                                3784536A1DFA882800FADCEE /* Assets.xcassets in Resources */,
-                               378453681DFA882800FADCEE /* Main.storyboard in Resources */,
                        );
                        runOnlyForDeploymentPostprocessing = 0;
                };
diff --git a/TextFieldFoolin/AppDelegate.m b/TextFieldFoolin/AppDelegate.m
index bbe6a44..9895e85 100644
--- a/TextFieldFoolin/AppDelegate.m
+++ b/TextFieldFoolin/AppDelegate.m
@@ -16,6 +16,9 @@ @implementation AppDelegate


 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
+    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
+    [self.window makeKeyAndVisible];
+    self.window.rootViewController = [[UIViewController alloc] init];
     // Override point for customization after application launch.
     return YES;
 }
diff --git a/TextFieldFoolin/Info.plist b/TextFieldFoolin/Info.plist
index 38e98af..b8901ee 100644
--- a/TextFieldFoolin/Info.plist
+++ b/TextFieldFoolin/Info.plist
@@ -22,8 +22,6 @@
        <true/>
        <key>UILaunchStoryboardName</key>
        <string>LaunchScreen</string>
-       <key>UIMainStoryboardFile</key>
-       <string>Main</string>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
                <string>armv7</string>
```

## TODOs
- Clear out LaunchScreen.storyboard and replace with LaunchScreen.xib, add entry to Info.plist
