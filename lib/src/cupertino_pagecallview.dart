import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pagecall_flutter/pagecall_flutter.dart';
import 'package:pagecall_flutter/platform_interface.dart';

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
