import 'dart:async';

import 'package:church_platform/net/API.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:validate/validate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegisterWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = '注册';

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          //centerTitle: true,
          elevation:
          (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
          
        ),
        body: MyCustomForm()
    );
  }
}

class _RegisterData {
  String username;
  String email;
  String password;
  String role = "2";
  String churchCode;
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  _RegisterData _data = new _RegisterData();

  bool _saving = false;

//  String _validateEmail(String value) {
//    // If empty value, the isEmail function throw a error.
//    // So I changed this function with try and catch.
//    try {
//      Validate.isEmail(value);
//    } catch (e) {
//      return 'The E-mail Address must be a valid email address.';
//    }
//
//    return null;
//  }
//
//  String _validatePassword(String value) {
//    if (value.length < 8) {
//      return 'The Password must be at least 8 characters.';
//    }
//
//    return null;
//  }

//  void submit() {
//    if (this._formKey.currentState.validate()) {
//      _formKey.currentState.save(); // Save our form now.
//
//      print('Printing the login data.');
//      print('Email: ${_data.username}');
//      print('Password: ${_data.password}');
//
//    }
//  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }


  Widget _buildWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '请输入教会码',
                labelText: '教会码'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '教会码不能为空';
              }
              return null;
            },
            onChanged: (text) {
//              print("教会码: $text");
            },
            onSaved: (String value) => _data.churchCode = value,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '请输入用户名',
                labelText: '用户名'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '用户名不能为空';
              }
              return null;
            },
            onChanged: (text) {
//              print("用户名: $text");
            },
            onSaved: (String value) => _data.username = value,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '请输入邮箱',
                labelText: '邮箱'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '邮箱不能为空';
              }
              return null;
            },
            onChanged: (text) {
//              print("邮箱: $text");
            },
            onSaved: (String value) => _data.email = value,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
//              border: InputBorder.none,
                hintText: '请输入密码',
                labelText: '密码'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '密码不能为空';
              }
//                  if (value != "123456"){
//                    return '密码错误';
//                  }
              return null;
            },
            controller: myController,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
                onPressed: () async {

                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      _saving = true;
                    });

                    try{
                      
                      bool success = await API().register(_data.churchCode,_data.username, _data.email, myController.text);

                      setState(() {
                        _saving = false;
                      });

                      if(success != null && success == true){

                        showToast(
                            "注册成功",
                            duration: Duration(seconds: 2),
                            position: ToastPosition.center,
                            backgroundColor: Colors.black.withOpacity(0.8),
                            radius: 13.0,
                            textStyle: TextStyle(fontSize: 18.0),
                            onDismiss: (){
                              Navigator.of(context).pop();
                            }
                        );

                      }else{

                        showToast(
                          "注册失败",
                          duration: Duration(seconds: 2),
                          position: ToastPosition.center,
                          backgroundColor: Colors.black.withOpacity(0.8),
                          radius: 13.0,
                          textStyle: TextStyle(fontSize: 18.0),
                        );
                      }
                    }catch (e){
                      setState(() {
                        _saving = false;
                      });

                      showToast(
                        "注册失败-" + e.toString(),
                        duration: Duration(seconds: 5),
                        position: ToastPosition.center,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        radius: 13.0,
                        textStyle: TextStyle(fontSize: 18.0),
                      );
                    }

                    return;

                  }else{

                  }
                },
                child: Text('注册',
                    style: new TextStyle(
                        color: Colors.white)),
                color: Theme.of(context).buttonColor
            ),
            margin: new EdgeInsets.only(
                top: 20.0
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(child:  Container(
        padding: EdgeInsets.all(20.0),
        child:  _buildWidget()
    ),inAsyncCall:_saving ,);
  }
}

