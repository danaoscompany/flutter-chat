import 'dart:convert';

import 'package:flutter/material.dart';
import 'global.dart';
import 'package:flutter/services.dart';
import 'package:chat/home.dart';

void main() {
  runApp(Login(null));
}

class Login extends StatefulWidget {
  final context;
  Login(this.context);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.example.chat/chat');
  var nameController = TextEditingController(text: "");

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
                      SizedBox(height: 10),
                      Container(width: width-32-32, height: 45, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                if (nameController.text.trim() == "") {
                                  Global.show("Mohon masukkan nama pengguna");
                                  return;
                                }
                                var fd = await Global.showProgressDialog(context, "Sedang masuk...");
                                Global.httpGet(context, Uri.parse("https://api.mesibo.com/api.php?token=rx4n6uh438unnoqw08lj8bcmo61uu0e3z42mydswg8re2f5sklk1ap633ltc00ea&op=useradd&appid=com.example.chat&addr="+nameController.text.trim()),
                                    onSuccess: (response) async {
                                      var obj = jsonDecode(response);
                                      Global.ACCESS_TOKEN = obj['user']['token'].toString();
                                      try {
                                        final result = await platform.invokeMethod('startChat', {
                                          "access_token": Global.ACCESS_TOKEN
                                        });
                                        print("RESULT: "+result);
                                      } on PlatformException catch (e) {
                                        print(e);
                                      }
                                      await Global.hideProgressDialog(context, fd);
                                      Global.replaceScreen(context, Home(context));
                                    });
                              },
                              child: Center(
                                  child: Text("Masuk", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
                              )
                          ))
                    ]
                )
            )
        )
    )));
  }
}
