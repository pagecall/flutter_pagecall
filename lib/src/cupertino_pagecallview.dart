import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pagecall/flutter_pagecall.dart';
import 'package:flutter_pagecall/platform_interface.dart';

class CupertinoPagecallView extends PlatformPagecallView {
  @override
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    required viewType,
    required onPlatformViewCreated,
  }) {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams?.toMap(),
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: onPlatformViewCreated,
    );
  }
}
