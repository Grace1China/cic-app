import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/utils/RegExpUtils.dart';
import 'package:church_platform/utils/ValidateUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';

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
        body: SingleChildScrollView(child: MyCustomForm())
    );
  }
}

class _RegisterData {
  String username;
  String email;
  String verifyCode;
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
//  final _emailKey = GlobalKey<FormState>();  无效

  final myController = TextEditingController();
  final myconfpwdController = TextEditingController();

  _RegisterData _data = new _RegisterData();

  bool _saving = false;

  /// 倒计时的计时器。
  Timer _timer;
  int MAX_SECONDS = 10;
  /// 当前倒计时的秒数。
  int _seconds;
  String _verifyStr = '获取验证码';
  bool _verifyAvailable = true;
  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _verifyAvailable = false;
    _seconds = MAX_SECONDS;
    _timer = Timer.periodic(
        Duration(seconds: 1),(timer) {
          if (_seconds == 0) {
            _cancelTimer();
            _seconds = MAX_SECONDS;
            _verifyAvailable = true;
            setState(() {});
            return;
          }
          _seconds--;
          _verifyStr = '已发送$_seconds'+'s';
          setState(() {});
          if (_seconds == 0) {
            _verifyAvailable = true;
            _verifyStr = '重新发送';
          }
        });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

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
    _timer?.cancel();
    _timer = null;
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
              _data.churchCode = text;
            },
            onSaved: (String value) => _data.churchCode = value,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
                hintText: '请输入用户名',
                labelText: '用户名'
            ),
            validator:ValidateUsername,
            onChanged: (text) {
//              print("用户名: $text");
              _data.username = text;
            },
            onSaved: (String value) => _data.username = value,
          ),
          TextFormField(
//            key: _emailKey,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '请输入邮箱',
                labelText: '邮箱'
            ),
            validator: ValidateEmail,
            onChanged: (text) {
//              print("邮箱: $text");
              _data.email = text;
            },
            onSaved: (String value) => _data.email = value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: '请输入验证码',
                      labelText: '验证码'
                  ),
                  validator: ValidateVerifyCode,
                  onChanged: (text) {
                    _data.verifyCode = text;
                  },
                  onSaved: (String value) => _data.verifyCode = value,
                ),
              ),
              Container(
                width: 110,
                height: 40,
                color: _verifyAvailable ? Theme.of(context).buttonColor : Theme.of(context).disabledColor,
                child: FlatButton(onPressed: !_verifyAvailable ? null: () async {

                  String errMsg = ValidateEmail(_data.email);
                  if(errMsg != null){
                    showToast(
                      errMsg,
                      duration: Duration(seconds: 2),
                      position: ToastPosition.center,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      radius: 13.0,
                      textStyle: TextStyle(fontSize: 18.0),
                    );
                    return;
                  }

                  if (errMsg == null) {

                    _startTimer();
                    _verifyStr = '已发送$_seconds'+'s';
                    setState(() {});

                    try{

                      String msg = await API().generateVerifyCode(_data.email);

                      setState(() {
                        _saving = false;
                      });

                      if(msg != null && msg.isNotEmpty){

                        showToast(
                            msg,
                            duration: Duration(seconds: 2),
                            position: ToastPosition.center,
                            backgroundColor: Colors.black.withOpacity(0.8),
                            radius: 13.0,
                            textStyle: TextStyle(fontSize: 18.0),
                        );

                      }else{

                        showToast(
                          "发送失败",
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
                        e.toString(),
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
                  child: Text(_verifyStr,style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
//              border: InputBorder.none,
                hintText: '请输入密码',
                labelText: '密码'
            ),
            validator:ValidatePWD,
            controller: myController,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
//              border: InputBorder.none,
                hintText: '请再次输入密码',
                labelText: '再次输入密码'
            ),
            validator: ValidatePWD,
            controller: myconfpwdController,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
                onPressed: () async {

                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      _saving = true;
                    });

                    try{
                      bool success = await API().register(churchCode: _data.churchCode,
                          username: _data.username,
                          email: _data.email,
                          verify_code: _data.verifyCode,
                          pwd: myController.text,
                          confirmpwd: myconfpwdController.text);

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
                        e.toString(),
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
                child: Text('注册',style: TextStyle(color: Colors.white)),
                color: Theme.of(context).buttonColor),
                margin: EdgeInsets.only(top: 20.0),
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

