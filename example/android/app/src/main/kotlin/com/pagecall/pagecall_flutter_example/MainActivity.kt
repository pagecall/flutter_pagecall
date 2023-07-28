package com.pagecall.flutter_pagecall_example

import android.view.KeyEvent
import com.pagecall.flutter_pagecall.FlutterPagecallView
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        for (instance in FlutterPagecallView.instances) {
            if(instance.handleKeyDownEvent(keyCode, event)) {
               return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }
}
