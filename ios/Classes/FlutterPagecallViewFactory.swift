import Flutter

public class FlutterPagecallViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let channel = FlutterMethodChannel(name: "com.pagecall/flutter_pagecall$\(viewId)", binaryMessenger: messenger)
        
        return FlutterPagecallView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            channel: channel)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
