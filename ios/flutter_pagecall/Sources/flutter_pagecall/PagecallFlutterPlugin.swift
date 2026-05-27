import Flutter
#if SWIFT_PACKAGE
import PagecallCore
#else
import Pagecall
#endif

public class PagecallFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let messenger = registrar.messenger()
      let factory = FlutterPagecallViewFactory(messenger: messenger)

      registrar.register(factory, withId: "com.pagecall/flutter_pagecall")

      PagecallWebView.configure()
  }
}
