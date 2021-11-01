import 'dart:convert';

import 'package:flutter/material.dart';
import 'global.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Home(null));
}

class Home extends StatefulWidget {
  final context;
  Home(this.context);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.example.chat/chat');
  var nameController = TextEditingController(text: "");
  var messageController = TextEditingController(text: "");
  var receivedMessages = [];

  Future<void> sendMessage() async {
    try {
      final result = await platform.invokeMethod('sendMessage', {
        "to": nameController.text.trim(),
        "message": messageController.text.trim()
      });
      print("RESULT: "+result);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(body: SafeArea(child: Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama pengguna:"),
                SizedBox(height: 4),
                Container(width: width-32-32, height: 45, decoration: BoxDecoration(color: Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(8)), child: Flexible(
                    child: TextField(decoration: new InputDecoration(counterText: "", border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintStyle: TextStyle(color: Color(0xFF9CA4AC), fontSize: 14), hintText: "Nama Pengguna", contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15)), textAlignVertical: TextAlignVertical.center, controller: nameController, keyboardType: TextInputType.text, style: TextStyle(fontSize: 14))
                )),
                SizedBox(height: 8),
                Text("Pesan yang ingin dikirim:"),
                SizedBox(height: 4),
                Container(width: width-32-32, height: 45, decoration: BoxDecoration(color: Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(8)), child: Flexible(
                    child: TextField(decoration: new InputDecoration(counterText: "", border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintStyle: TextStyle(color: Color(0xFF9CA4AC), fontSize: 14), hintText: "Pesan", contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15)), textAlignVertical: TextAlignVertical.center, controller: messageController, keyboardType: TextInputType.text, style: TextStyle(fontSize: 14))
                )),
                SizedBox(height: 10),
                Container(width: width-32-32, height: 45, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (nameController.text.trim() == "") {
                        Global.show("Mohon masukkan nama pengguna");
                        return;
                      }
                      if (messageController.text.trim() == "") {
                        Global.show("Mohon masukkan pesan");
                        return;
                      }
                      try {
                        final result = await platform.invokeMethod('sendMessage', {
                          "to": nameController.text.trim(),
                          "message": messageController.text
                        });
                        print("RESULT: "+result);
                      } on PlatformException catch (e) {
                        print(e);
                      }
                    },
                    child: Center(
                      child: Text("Kirim", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
                    )
                  )),
                Container(
                  width: width-32-32,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var receivedMessage in receivedMessages)
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(receivedMessage['message'].toString(), style: TextStyle(color: Colors.black, fontSize: 15))
                          )
                      ]
                    )
                  )
                )
              ]
          )
        )
      )
    )));
  }
}
