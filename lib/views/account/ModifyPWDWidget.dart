import 'package:church_platform/main.dart';
import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/models/CustomUser.dart';
import 'package:church_platform/utils//SharedPreferencesUtils.dart';
import 'package:church_platform/utils/RegExpUtils.dart';
import 'package:church_platform/utils/ValidateUtils.dart';
import 'package:church_platform/views/lordday/LorddayInfoMainWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';


class ModifyPWDWidget extends StatefulWidget {
  CustomUser user;
  ModifyPWDWidget({Key key, this.user}) : super(key: key);

  @override
  _ModifyPWDWidgetState createState() => _ModifyPWDWidgetState();
}


class _ModifyPWDWidgetState extends State<ModifyPWDWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String errmsg;
  String oldpwd;

  final mypwdController = TextEditingController();
  final myconfpwdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetch();
  }

  @override
  void dispose() {
    mypwdController.dispose();
    myconfpwdController.dispose();
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
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
//            autofocus: true,
              decoration: InputDecoration(
                  hintText: '请输入旧密码',
                  labelText: '旧密码'
              ),
              validator: ValidatePWD,
              onChanged: (text) {
                oldpwd = text;
              },
              onSaved: (String value) => oldpwd = value,
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
              controller: mypwdController,
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
              controller: myconfpwdController,
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
                        bool success = await API().updateUserPWD(oldpwd, mypwdController.text, myconfpwdController.text);

                        setState(() {
                          _loading = false;
                        });
                        if(success){
                          showToast(
                              "修改成功",
                              duration: Duration(seconds: 2),
                              position: ToastPosition.center,
                              backgroundColor: Colors.black.withOpacity(0.8),
                              radius: 13.0,
                              textStyle: TextStyle(fontSize: 18.0),
                              onDismiss: (){
                                Navigator.pop(context);
                              }
                          );
                        }

                      }catch(e){
                        setState(() {
                          _loading = false;
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
  }}
