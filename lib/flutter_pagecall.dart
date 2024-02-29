import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pagecall/platform_interface.dart';
import 'package:flutter_pagecall/src/android_pagecallview.dart';
import 'package:flutter_pagecall/src/cupertino_pagecallview.dart';

//ignore: must_be_immutable
class PagecallView extends StatefulWidget {
  final String? mode;

  final String? roomId;

  final String? accessToken;

  final String? queryParams;

  final void Function(PagecallViewController controller)? onViewCreated;

  final void Function()? onLoaded;
  final void Function(String message)? onMessage;
  final void Function(String reason)? onTerminated;
  final void Function(String error)? onError;

  final bool debuggable;

  const PagecallView({
    Key? key,
    this.mode,
    this.roomId,
    this.accessToken,
    this.queryParams,
    this.onViewCreated,
    this.onLoaded,
    this.onMessage,
    this.onTerminated,
    this.onError,
    this.debuggable = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PagecallViewState createState() => _PagecallViewState();
}

class _PagecallViewState extends State<PagecallView> {
  static const String viewType = 'com.pagecall/flutter_pagecall';

  late PagecallViewController _controller;

  static PlatformPagecallView? _platform;

  static set platform(PlatformPagecallView? platform) {
    _platform = platform;
  }

  static PlatformPagecallView? get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidPagecallView();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoPagecallView();
          break;
        default:
          throw UnsupportedError(
            "UnsupportedError for platform=$defaultTargetPlatform",
          );
      }
    }
    return _platform;
  }

  @override
  Widget build(BuildContext context) {
    return platform!.build(
      context: context,
      creationParams: CreationParams(
        mode: widget.mode,
        roomId: widget.roomId,
        accessToken: widget.accessToken,
        queryParams: widget.queryParams,
        debuggable: widget.debuggable,
      ),
      viewType: viewType,
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    _controller = PagecallViewController(id, widget);

    if (widget.onViewCreated != null) {
      widget.onViewCreated!(_controller);
    }
  }

  @override
  void dispose() {
    _controller._channel.invokeMethod("dispose");
    super.dispose();
  }
}

class CreationParams {
  final String? mode; // TODO: String -> enum

  final String? roomId;

  final String? accessToken;

  final String? queryParams;

  final bool debuggable;

  CreationParams({
    this.mode,
    this.roomId,
    this.accessToken,
    this.queryParams,
    this.debuggable = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "mode": mode,
      "roomId": roomId,
      "accessToken": accessToken,
      "queryParams": queryParams,
      "debuggable": debuggable
    };
  }
}

class PagecallViewController {
  PagecallView? _pagecallView;
  late MethodChannel _channel;
  dynamic _id;

  PagecallViewController(dynamic id, PagecallView pagecallView) {
    _id = id;
    String channelName = "com.pagecall/flutter_pagecall\$$_id";

    _channel = MethodChannel(channelName);
    _channel.setMethodCallHandler(handleMethod);
    _pagecallView = pagecallView;
  }

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onMessage':
        if (_pagecallView != null) {
          String message = call.arguments.toString();
          if (_pagecallView?.onMessage != null) {
            _pagecallView?.onMessage!(message);
          }
        }
        break;
      case 'onLoaded':
        if (_pagecallView != null) {
          if (_pagecallView?.onLoaded != null) {
            _pagecallView?.onLoaded!();
          }
        }
        break;
      case 'onTerminated':
        if (_pagecallView != null) {
          String reason = call.arguments.toString();
          if (_pagecallView?.onTerminated != null) {
            _pagecallView?.onTerminated!(reason);
          }
        }
        break;
      case 'onError':
        if (_pagecallView != null) {
          String error = call.arguments.toString();
          if (_pagecallView?.onError != null) {
            _pagecallView?.onError!(error);
          }
        }
        break;

      default:
        throw UnimplementedError('Unimplemented method=${call.method}');
    }

    return null;
  }

  Future<void> sendMessage(String message) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('message', () => message);
    await _channel.invokeMethod('sendMessage', args);
  }
}
