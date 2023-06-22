package com.pagecall.pagecall_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** PagecallFlutterPlugin */
class PagecallFlutterPlugin : FlutterPlugin/*, MethodCallHandler*/ {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
//  private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pagecall_flutter")
//    channel.setMethodCallHandler(this)

        val messenger = flutterPluginBinding.binaryMessenger
        val registry = flutterPluginBinding.platformViewRegistry

        registry.registerViewFactory(
            "com.pagecall/pagecall_flutter",
            FlutterPagecallViewFactory(messenger)
        )
    }

//    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
//        } else {
//            result.notImplemented()
//        }
//    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//        channel.setMethodCallHandler(null)
    }
}
