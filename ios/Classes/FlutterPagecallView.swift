import Flutter
import UIKit
import WebKit
import Pagecall

func stringToQueryItems(_ queryString: String) -> [URLQueryItem] {
    return queryString.components(separatedBy: "&").compactMap { component in
        let keyValuePair = component.components(separatedBy: "=")
        guard keyValuePair.count == 2 else { return nil }
        return URLQueryItem(name: keyValuePair[0], value: keyValuePair[1])
    }
}

public class FlutterPagecallView: NSObject, FlutterPlatformView {
    private var _view: UIView

    private var mode: PagecallMode?
    private var roomId: String?
    private var accessToken: String?

    public init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?, channel: FlutterMethodChannel?) {
        _view = FlutterEmbedView(frame: frame, channel: channel, creationParams: args as? [String: Any])

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
    private var queryParams: String?
    private var debuggable: Bool = false
    private var useNativePenEvent: Bool = false
    private var unsafeCustomUrl: String?

    convenience init(frame: CGRect, channel: FlutterMethodChannel?, creationParams: [String: Any]?) {
        self.init(frame: frame)
        self.channel = channel

        initParams(creationParams)
        initMethodChannel()

        if #available(iOS 16.4, *) {
            pagecallWebView.isInspectable = debuggable
        }

        pagecallWebView.useNativePenEvent = useNativePenEvent

        pagecallWebView.delegate = self

        if let unsafeUrl = unsafeCustomUrl {
            _ = pagecallWebView.load(URLRequest(url: URL(string: unsafeUrl)!))
            self.addSubview(pagecallWebView)
            return
        }

        var queryItems: [URLQueryItem] = Array()

        if let queryParams = queryParams {
            queryItems.append(contentsOf: stringToQueryItems(queryParams))
        }
        queryItems.append(URLQueryItem(name: "access_token", value: accessToken))

        _ = pagecallWebView.load(roomId: roomId!, mode: mode!, queryItems: queryItems)

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
        case "dispose":
            DispatchQueue.main.async {
                self.dispose()
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func initParams(_ params: [String: Any]?) {
        guard let params = params else { return }

        if let val = params["mode"] as? String {
            if val == "meet" {
                mode = PagecallMode.meet
            } else if val == "replay" {
                mode = PagecallMode.replay
            }
        }

        if let val = params["roomId"] as? String {
            roomId = val
        }

        if let val = params["accessToken"] as? String {
            accessToken = val
        }

        if let val = params["queryParams"] as? String {
            queryParams = val
        }

        if let val = params["debuggable"] as? Bool {
            debuggable = val
        }

        if let val = params["useNativePenEvent"] as? Bool {
            useNativePenEvent = val
        }

        if let val = params["unsafeCustomUrl"] as? String {
            unsafeCustomUrl = val
        }
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
        switch reason {
          case .internal:
            self.channel?.invokeMethod("onTerminated", arguments: "internal")
          case .other(let reasonString):
            self.channel?.invokeMethod("onTerminated", arguments: reasonString)
        }
    }

    func pagecallDidReceive(_ view: PagecallWebView, message: String) {
        self.channel?.invokeMethod("onMessage", arguments: message)
    }

    func pagecallWillNavigate(_ view: PagecallWebView, url: String) {
        self.channel?.invokeMethod("onWillNavigate", arguments: url)
    }

    private func dispose() {
        self.channel?.setMethodCallHandler(nil)
        self.pagecallWebView.evaluateJavaScript("window.Pagecall?.terminate()")
        self.pagecallWebView.cleanup()
        self.pagecallWebView.removeFromSuperview()
        self.pagecallWebView.delegate = nil
    }
}
