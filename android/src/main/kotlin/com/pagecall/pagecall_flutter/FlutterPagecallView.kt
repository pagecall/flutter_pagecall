package com.pagecall.pagecall_flutter

import android.content.Context
import android.net.Uri
import android.os.Handler
import android.view.View
import android.webkit.WebView
import com.pagecall.PagecallWebView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class FlutterPagecallView(
    context: Context,
    private val channel: MethodChannel,
    params: Map<String, Any?>
) : PlatformView, MethodCallHandler {

    private val pagecallWebView: PagecallWebView

    private var mode: String? = null
    private var roomId: String? = null
    private var accessToken: String? = null
    private var debuggable: Boolean = false

    init {
        initParams(params)

        channel.setMethodCallHandler(this)

        WebView.setWebContentsDebuggingEnabled(debuggable)

        pagecallWebView = PagecallWebView(context).apply {
            listenMessage {
                Handler(context.mainLooper).post {
                    channel.invokeMethod("onMessageReceived", it)
                }
            }
        }

        loadPage()
    }

    private fun initParams(params: Map<String, Any?>) {
        if (params.containsKey("mode")) {
            mode = params.getValue("mode")?.toString();
        }

        if (params.containsKey("roomId")) {
            roomId = params.getValue("roomId")?.toString()
        }

        if (params.containsKey("accessToken")) {
            accessToken = params.getValue("accessToken")?.toString()
        }

        if (params.containsKey("debuggable")) {
            debuggable = params.getOrDefault("debuggable", false) as Boolean
        }
    }

    private fun loadPage() {
        val url = Uri.parse("https://app.pagecall.com").buildUpon()
            .path(mode)
            .apply {
                if (roomId != null) {
                    appendQueryParameter("room_id", roomId)
                }
            }
            .apply {
                if (roomId != null) {
                    appendQueryParameter("access_token", accessToken)
                }
            }
            .build()

        pagecallWebView.loadUrl(url.toString())
    }

    override fun getView(): View = pagecallWebView

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments<Map<String, Any>>()

        when (call.method) {
            "sendMessage" -> {
                val message = arguments!!["message"] as? String
                message?.let { pagecallWebView.sendMessage(it) }
                result.success(null)
            }
        }
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
        pagecallWebView.destroy()
    }
}