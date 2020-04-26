import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/CustomUser.dart';
import 'package:church_platform/utils/ToasterUtils.dart';
import 'package:church_platform/utils/ValidateUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';

class ModifyPWDWidget extends StatefulWidget {
  CustomUser user;
  ModifyPWDWidget({Key key, this.user}) : super(key: key);

  @override
  _ModifyPWDWidgetState createState() => _ModifyPWDWidgetState();
}

class _UpdatePWDData {
//  String email;
  String verifyCode;
//  String pwd;
//  String cofirmPWD;
}

class _ModifyPWDWidgetState extends State<ModifyPWDWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String errmsg;

  _UpdatePWDData _data = _UpdatePWDData();
  final myPWDController = TextEditingController();
  final myConfimPWDController = TextEditingController();


  @override
  void initState() {
    super.initState();

    fetch();
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    myPWDController.dispose();
    myConfimPWDController.dispose();
    super.dispose();
  }

  void fetch() async{
    try {
      widget.user = await API().getUserInfo();
      setState(() {
        errmsg = null;
      });
    }catch(e){
      setState((){
        errmsg = e.toString();
        widget.user = null;
      });
    }
  }

  Widget buildContent(BuildContext context) {
    if (errmsg != null && errmsg.isNotEmpty) {
      return Text(errmsg);
    } else {
      return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          children: [
  //            TextFormField(
  //              keyboardType: TextInputType.visiblePassword,
  //              obscureText: true,
  ////            autofocus: true,
  //              decoration: InputDecoration(
  //                  hintText: '请输入旧密码',
  //                  labelText: '旧密码'
  //              ),
  //              validator: ValidatePWD,
  //              onChanged: (text) {
  //                oldpwd = text;
  //              },
  //              onSaved: (String value) => oldpwd = value,
  //            ),
              TextFormField(
  //            key: _emailKey,
                keyboardType: TextInputType.emailAddress,
                initialValue:widget.user.email,
                enabled: false,
                decoration: InputDecoration(
                    hintText: '请输入邮箱',
                    labelText: '邮箱'
                ),
                validator: ValidateEmail,
//                onChanged: (text) {
//  //              print("邮箱: $text");
//                  _data.email = text;
//                },
//                onSaved: (String value) => _data.email = value,
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

                    String errMsg = ValidateEmail(widget.user.email);
                    if(errMsg != null){
                      ToasterUtils.show(context,msg: errMsg);
                      return;
                    }

                    if (errMsg == null) {

                      try{
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _loading = true;
                        });

                        String msg = await API().generateVerifyCode(email:widget.user.email,modifypwd: true);

                        if(msg != null && msg.isNotEmpty){

                          _startTimer();
                          setState(() {
                            _verifyStr = '已发送$_seconds'+'s';
                            _loading = false;
                          });

                          ToasterUtils.show(context,msg: msg);
                        }else{
                          ToasterUtils.show(context,msg: "发送失败");

                        }
                      }catch (e){
                        setState(() {
                          _loading = false;
                        });
                        ToasterUtils.show(context,msg: e.toString(),duration: 5);
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
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
//              border: InputBorder.none,
                  hintText: '请输入新密码',
                  labelText: '新密码'
              ),
              validator:ValidatePWD,
              controller: myPWDController,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
//              border: InputBorder.none,
                  hintText: '请再次输入新密码',
                  labelText: '再次输入新密码'
              ),
              validator: ValidatePWD,
              controller: myConfimPWDController,
            ),
            Container(
//            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      setState(() {
                        _loading = true;
                      });

                      try{
                        FocusScope.of(context).requestFocus(FocusNode());
                        bool success = await API().updateUserPWD(widget.user.email,_data.verifyCode, myPWDController.text, myConfimPWDController.text);

                        setState(() {
                          _loading = false;
                        });
                        if(success){
                          ToasterUtils.show(context,msg: "修改成功",onDismiss: (){
                            Navigator.pop(context);
                          });
                        }

                      }catch(e){
                        setState(() {
                          _loading = false;
                        });
                        ToasterUtils.show(context,msg:e.toString());
                      }
                    }
                  },
                  child: Text('修改',style: TextStyle(color: Colors.white)),
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('修改密码'),
          //centerTitle: true,
          elevation:
          (Theme
              .of(context)
              .platform == TargetPlatform.iOS ? 0.0 : 4.0),

        ),
        body: ModalProgressHUD(
            inAsyncCall: _loading,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: buildContent(context)
        )
    );
  }
}
