package com.example.chat

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.Toast
import com.mesibo.api.Mesibo
import com.mesibo.api.Mesibo.MessageListener
import com.mesibo.api.Mesibo.MessageParams
import io.flutter.plugin.common.MethodChannel
import com.mesibo.api.MesiboProfile
import org.json.JSONObject
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.chat/chat"
    var userProfile: MesiboProfile? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messageListener = object : MessageListener {

            override fun Mesibo_onMessage(
                messageParams: MessageParams,
                data: ByteArray
            ): Boolean {
                Toast.makeText(this@MainActivity, "RECEIVED MESSAGE: "+String(data), Toast.LENGTH_SHORT).show()
                return false
            }
            override fun Mesibo_onMessageStatus(messageParams: MessageParams) {}
            override fun Mesibo_onActivity(messageParams: MessageParams, i: Int) {}
            override fun Mesibo_onLocation(
                messageParams: MessageParams,
                location: Mesibo.Location
            ) {
            }
            override fun Mesibo_onFile(
                messageParams: MessageParams,
                fileInfo: Mesibo.FileInfo
            ) {
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            var arguments: HashMap<String, String> = call.arguments as HashMap<String, String>;
            if (call.method == "startChat") {
                var accessToken = arguments.get("access_token");
                val api = Mesibo.getInstance()
                api.init(applicationContext)
                Mesibo.addListener(object : Mesibo.ConnectionListener {

                    override fun Mesibo_onConnectionStatus(status: Int) {
                        Log.e(Build.MODEL, "CONNECTION STATUS = "+status)
                    }
                })
                Mesibo.addListener(messageListener)
                Mesibo.setAccessToken(accessToken)
                Mesibo.setDatabase("mydb", 0)
                Mesibo.start()
                result.success("startChat, access token: "+accessToken)
            } else if (call.method == "sendMessage") {
                var to = arguments.get("to");
                var message = arguments.get("message");
                var userProfile = Mesibo.getProfile(to)
                userProfile?.sendMessage(Mesibo.random(), message)
                result.success("sendMessage, to: "+to+", message: "+message)
            } else {
                result.notImplemented()
            }
        }
    }
}
