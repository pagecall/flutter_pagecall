# Official Pagecall Flutter SDK

This is the official Pagecall Flutter SDK developed and maintained by Pagecall Inc.


## Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:
```yaml
dependencies:
  flutter_pagecall: <latest_version>
```

For Android build, generate Github access token with `read:packages` scope on Github profile setting, then set `GITHUB_USERNAME` and `GITHUB_TOKEN` for your environment variables or put these as properties of the Android root project when running your app.
```shell
GITHUB_USERNAME=<username> GITHUB_TOKEN=<token> flutter run  # when running as command
```

For iOS build, in `Info.plist` of your iOS workspace, make sure you set `NSMicrophoneUsageDescription`. Also, those `UIBackgroundModes` should be enabled: `audio`, `fetch`, `voip`.


## Usage

Check the following Dart code or `example` directory of this repository.

```dart
PagecallViewController? _pagecallViewController;
...
Expanded(
  child: PagecallView(
    mode: "meet",
    roomId: "<room id>",
    accessToken: "<access token>",
    onViewCreated: (controller) {
      _pagecallViewController = controller;
    },
    onLoaded: () {
      debugPrint('onLoaded');
    },
    onMessage: (message) {
      debugPrint('Received message=$message');
    },
    onTerminated: (reason) {
      debugPrint('onTerminated')
    },
    debuggable: true,
  ),
),
...
_pagecallViewController?.sendMessage(message);  // when invoking sendMessage
```

## Android Key Event Handling

For handling key events on Android, you need to override the `onKeyDown` function in your `MainActivity.kt` as follows:

```kotlin
override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
    for (instance in FlutterPagecallView.instances) {
        instance.handleKeyDownEvent(keyCode, event)
    }
    return super.onKeyDown(keyCode, event)
}
```
You can refer to the MainActivity.kt in the example app for more details.
## Compatibility

The following matrix lists the minimum support for Pagecall Flutter SDK version.

|Pagecall Flutter|iOS|Android minSdk|
|-|-|-|
| `1.0.+` | `14+` | `24+` |


## Need Help?

[Visit Pagecall](https://pagecall.com)