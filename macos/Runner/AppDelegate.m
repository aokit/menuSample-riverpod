#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(NSApplication *)application didFinishLaunchingWithOptions:(NSDictionary<NSApplicationLaunchOptionsKey,id> *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [self setupWindowObserver];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)setupWindowObserver {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self
             selector:@selector(windowDidChangeScreenProfile:)
                 name:NSWindowDidChangeScreenProfileNotification
               object:nil];
}

- (void)windowDidChangeScreenProfile:(NSNotification *)notification {
  NSWindow *window = (NSWindow *)notification.object;
  NSRect frame = [window frame];

  // Flutterにイベントを送信
  FlutterViewController *flutterController = (FlutterViewController *)self.window.rootViewController;
  FlutterMethodChannel *channel = [FlutterMethodChannel
    methodChannelWithName:@"window_channel"
          binaryMessenger:flutterController.binaryMessenger];
  [channel invokeMethod:@"windowResized" arguments:@{@"width": @(frame.size.width), @"height": @(frame.size.height)}];
}

@end
