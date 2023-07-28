package com.pagecall.flutter_pagecall

import android.content.Context
import android.net.Uri
import android.os.Handler
import android.view.KeyEvent
import android.view.View
import android.webkit.WebView
import com.pagecall.PagecallWebView
import com.pagecall.TerminationReason
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

fun String.toMap(): Map<String, String> {
    return this.split("&")
        .mapNotNull {
            val pair = it.split("=")
            if (pair.size == 2) pair[0] to pair[1] else null
        }
        .toMap()
}
class FlutterPagecallView(
    context: Context,
    private val channel: MethodChannel,
    params: Map<String, Any?>
) : PlatformView, MethodCallHandler {

    private val pagecallWebView: PagecallWebView

    private var mode: String? = null
    private var roomId: String? = null
    private var accessToken: String? = null
    private var queryParams: String? = null
    private var debuggable: Boolean = false

    companion object {
        val instances = mutableListOf<FlutterPagecallView>()
    }
    init {
        instances.add(this)
        initParams(params)

        channel.setMethodCallHandler(this)

        WebView.setWebContentsDebuggingEnabled(debuggable)

        pagecallWebView = PagecallWebView(context)

        loadPage()

        pagecallWebView.setListener(object: PagecallWebView.Listener {
            override fun onLoaded() {
                Handler(context.mainLooper).post {
                    channel.invokeMethod("onLoaded", null)
                }
            }

            override fun onMessage(message: String) {
                Handler(context.mainLooper).post {
                    channel.invokeMethod("onMessage", message)
                }
            }

            override fun onTerminated(reason: TerminationReason) {
                Handler(context.mainLooper).post {
                    val reasonString = if (reason == TerminationReason.OTHER) reason.otherReason
                        else reason.value
                    channel.invokeMethod("onTerminated", reasonString)
                }
            }
        })
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

        if(params.containsKey("queryParams")) {
            queryParams = params.getValue("queryParams")?.toString()
        }

        if (params.containsKey("debuggable")) {
            debuggable = params.getOrDefault("debuggable", false) as Boolean
        }
    }

    private fun loadPage() {
        val queryMap = queryParams?.toMap()
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
            .apply {
                queryMap?.forEach { (key, value) ->
                    appendQueryParameter(key, value)
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
            "dispose" -> {
                dispose()
                result.success(null)
            }
        }
    }

    fun handleKeyDownEvent(keyCode: Int, event: KeyEvent?): Boolean {
        return pagecallWebView.handleVolumeKeys(keyCode, event)
    }
    override fun dispose() {
        instances.remove(this)
        channel.setMethodCallHandler(null)
        pagecallWebView.destroy()
    }
}