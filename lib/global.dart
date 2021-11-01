import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class Global {
    static const TIMEOUT = 2000;
    static const PROTOCOL = "http";
    static const HOST = "192.168.22.148";
    static const API_URL = PROTOCOL+"://"+HOST+"/login-api";
    static var ACCESS_TOKEN = "";

    static void navigate(context, screen) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }

    static void replaceScreen(context, screen) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
    }

    static void show(message) {
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }

    static void httpGet(string, uri, {var headers = null, onSuccess = null, onError = null, onTimeout = null}) async {
        if (headers == null) {
            headers = Map<String, String>();
        }
        var response = await http.get(uri, headers: headers).timeout(
  	        Duration(seconds: TIMEOUT),
  	        onTimeout: () {
  	         if (string == null) {
                Global.show("Batas maksimum koneksi terlampaui");
            } else {
                Global.show(string.text265);
            }
  	        if (onTimeout != null) {
                onTimeout();
            }
    	    return http.Response('Error', 500);
  	    }
	  );
         if (response.statusCode >= 200 && response.statusCode < 300) {
            if (onSuccess != null) {
                onSuccess(response.body);
            }
            } else {
                if (response.statusCode == 500) {
                    return;
                }
                Global.show(string.text6+" ["+response.statusCode.toString()+"]");
                if (onError != null) {
                    onError();
            }
        }
    }

  static void httpPost(string, uri, {var body = null, var headers = null, onSuccess = null, onError = null, onTimeout = null}) async {
    if (headers == null) {
      headers = Map<String, String>();
    }
    var response = await http.post(uri, headers: headers, body: body).timeout(
  	  Duration(seconds: TIMEOUT),
  	  onTimeout: () {
        Global.show(string.text265);
        if (onTimeout != null) {
          onTimeout();
        }
    	  return http.Response('Error', 500);
  	  },
	  );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (onSuccess != null) {
        onSuccess(response.body);
      }
    } else {
      if (response.statusCode == 500) {
        return;
      }
      Global.show(string.text6+" ["+response.statusCode.toString()+"]");
      if (onError != null) {
        onError();
      }
    }
  }

  static Future<ProgressDialog> showProgressDialog(BuildContext context, String message) async {
    ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
      message: message,
      messageTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
    await progressDialog.show();
    return progressDialog;
  }

  static Future<void> hideProgressDialog(BuildContext context, ProgressDialog dialog) async {
    if (dialog != null) {
      await dialog.hide();
    }
  }
}