import Flutter

public class PagecallFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let messenger = registrar.messenger()
      let factory = FlutterPagecallViewFactory(messenger: messenger)
      
      registrar.register(factory, withId: "com.pagecall/flutter_pagecall")
  }
}
