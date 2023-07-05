import Flutter
import UIKit
import WebKit
import Pagecall

public class FlutterPagecallView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    private var mode: PagecallMode?
    private var roomId: String?
    private var accessToken: String?
    
    public init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?, channel: FlutterMethodChannel?) {
        _view = FlutterEmbedView(frame: frame, channel: channel, creationParams: args as? [String : Any])
        
        super.init()
    }
    
    public func view() -> UIView {
        return _view
    }
}

class FlutterEmbedView: UIView, PagecallDelegate {
    let pagecallWebView = PagecallWebView()
    
    private var channel: FlutterMethodChannel?
    
    private var mode: PagecallMode?
    private var roomId: String?
    private var accessToken: String?
    private var debuggable: Bool = false
    
    convenience init(frame: CGRect, channel: FlutterMethodChannel?, creationParams: [String: Any]?) {
        self.init(frame: frame)
        self.channel = channel
        
        initParams(creationParams)
        initMethodChannel()
        
        if #available(iOS 16.4, *) {
            pagecallWebView.isInspectable = debuggable
        }
        
        pagecallWebView.delegate = self
        
        Task {
            await clearWebsideDataToInvalidateAccessToken()
            
            _ = pagecallWebView.load(roomId: roomId!, mode: mode!, queryItems: [URLQueryItem.init(name: "access_token", value: accessToken)])
        }
        
        self.addSubview(pagecallWebView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initMethodChannel() {
        self.channel?.setMethodCallHandler(self.handleMethodCall)
    }
    
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        
        switch call.method {
        case "sendMessage":
            if let message = arguments!["message"] as? String {
                DispatchQueue.main.async {
                    self.pagecallWebView.sendMessage(message: message, completionHandler: nil)
                }
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    private func initParams(_ params: [String: Any]?) {
        if params == nil {
            return
        }
        
        if let val = params!["mode"] as? String {
            if val == "meet" {
                mode = PagecallMode.meet
            } else if val == "replay" {
                mode = PagecallMode.replay
            }
        }
        
        if let val = params!["roomId"] as? String {
            roomId = val
        }
        
        if let val = params!["accessToken"] as? String {
            accessToken = val
        }
        
        if let val = params!["debuggable"] as? Bool {
            debuggable = val
        }
    }
    
    func clearWebsideDataToInvalidateAccessToken() async {
        let dataRecords = await WKWebsiteDataStore.default().dataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes())
        
        await WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: dataRecords)
    }
    
    public override func layoutSubviews() {
        pagecallWebView.frame = CGRect(x: self.frame.origin.x,
                                       y: self.frame.origin.y,
                                       width: self.frame.width,
                                       height: self.frame.height)
        super.layoutSubviews()
    }
    
    // MARK: PagecallDelegate
    func pagecallDidLoad(_ view: Pagecall.PagecallWebView) {
        self.channel?.invokeMethod("onLoaded", arguments: nil)
    }
    func pagecallDidTerminate(_ view: Pagecall.PagecallWebView, reason: Pagecall.TerminationReason) {
        self.channel?.invokeMethod("onTerminated", arguments: nil) // TODO: pass reason
    }
    
    func pagecallDidReceive(_ view: PagecallWebView, message: String) {
        self.channel?.invokeMethod("onMessage", arguments: message)
    }
}
