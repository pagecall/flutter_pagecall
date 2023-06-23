package com.pagecall.pagecall_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

class PagecallFlutterPlugin : FlutterPlugin {

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = flutterPluginBinding.binaryMessenger
        val registry = flutterPluginBinding.platformViewRegistry

        registry.registerViewFactory(
            "com.pagecall/pagecall_flutter",
            FlutterPagecallViewFactory(messenger)
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//        channel.setMethodCallHandler(null)
    }
}
