package com.pagecall.flutter_pagecall_example

import android.content.Intent
import android.view.KeyEvent
import com.pagecall.flutter_pagecall.FlutterPagecallView
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        FlutterPagecallView.instances.forEach { view ->
            view.onActivityResult(requestCode, resultCode, data)
        }
    }
}
