# Official Pagecall Flutter SDK

This is the official Pagecall Flutter SDK developed and maintained by Pagecall Inc.

## Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:
```yaml
dependencies:
  pagecall_flutter: <latest_version>
```

Generate Github access token with `read:packages` scope, then set `GITHUB_USERNAME` and `GITHUB_TOKEN` for your environment variables or put these as properties of the Android root project when running your app.
```shell
GITHUB_USERNAME=<username> GITHUB_TOKEN=<token> flutter run  # when running as command
```


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
    onMessageReceived: (message) {
      debugPrint('Received message=$message');
    },
    debuggable: true,
  ),
),
...
_pagecallViewController?.sendMessage(message);  // when invoking sendMessage
```

## Compatibility

The following matrix lists the minimum support for Pagecall Flutter SDK version.

|Pagecall Flutter|iOS|Android minSdk|
|-|-|-|
| `1.0.+` | `14+` | `24+` |

## Need Help?

[Visit Pagecall](https://pagecall.com)