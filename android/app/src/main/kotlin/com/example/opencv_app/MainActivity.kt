package com.example.opencv_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import com.alexandrofuchs.pylib.PyLibActivity

class MainActivity: FlutterActivity(){
    private lateinit var flutterEngineInstance: FlutterEngine
    private lateinit var channelInstance: MethodChannel
    private lateinit var pyLibActivity: PyLibActivity

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

       pyLibActivity = PyLibActivity()
       pyLibActivity.init(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        this.flutterEngineInstance = flutterEngine

        flutterEngineInstance.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        channelInstance = MethodChannel(flutterEngineInstance.dartExecutor.binaryMessenger, FlutterChannel.CHANNEL)


        channelInstance.setMethodCallHandler {
                call, result ->
            if(call.method.equals("processImage")) {
                if(call.arguments is String){
                    val res = pyLibActivity
                        .processImage(call.arguments as String)
                    result.success(res)
                }else{
                    result.success("parametro inválido")
                }

            } else {
                result.notImplemented()
            }
        }

        FlutterChannel.receiveMethodChannel(channelInstance)
        GeneratedPluginRegistrant.registerWith(flutterEngineInstance)
    }

}
