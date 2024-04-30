package com.example.opencv_app

import io.flutter.plugin.common.MethodChannel

class FlutterChannel {
    companion object{
        const val CHANNEL = "com.alexandrofuchs.pylib_channel"
        var methodChannel : MethodChannel? = null

        fun receiveMethodChannel(channel: MethodChannel){
            methodChannel = channel
        }
    }
}