import 'dart:async';

import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:validate/validate.dart';


class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = '登录';

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
    );
  }
}

class _LoginData {
  String email = '';
  String password = '';
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  _LoginData _data = new _LoginData();

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

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      print('Printing the login data.');
      print('Email: ${_data.email}');
      print('Password: ${_data.password}');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Text("用户名",style: TextStyle(fontSize: 16),),
//              SizedBox(width: 10),
//
//            ],
//          ),
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
                  if (value != "Daniel"){
                    return '用户名错误';
                  }
                  return null;
                },
                onChanged: (text) {
                  print("First text field: $text");
                },
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
                  if (value != "123456"){
                    return '密码错误';
                  }
                  return null;
                },
                controller: myController,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {

                        SharedPreferencesUtils.saveIsLogin();
                        Navigator.of(context).pop();
                        return;
//                        Scaffold.of(context)
//                            .showSnackBar(SnackBar(content: Text('正在登录...'),action: SnackBarAction(
//                          label: 'Dissmiss',
//                          textColor: Colors.yellow,
//                          onPressed: () {
//                            debugPrint("消失");
//                            //  Navigator.of(context).pop();
////                            _scaffoldKey.currentState.removeCurrentSnackBar();
////                            _formKey.currentState.hideCurrentSnackBar();
//                          },
//                        )));


                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Text("登录成功"),//Text(myController.text),
                            );
                          },
                        );

                        Timer(Duration(seconds: 3), () {
                          print("Yeah, this line is printed after 3 seconds");
                          SharedPreferencesUtils.saveIsLogin();
                          Navigator.of(context).pop();
                        });

                      }else{

                      }
                    },
                    child: Text('登录',
                        style: new TextStyle(
                            color: Colors.white)),
                    color: Colors.blue
                ),
                margin: new EdgeInsets.only(
                    top: 20.0
                ),
              )
            ],
          ),
        ),
    );
  }
}

