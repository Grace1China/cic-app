import 'package:church_platform/main.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/CustomUser.dart';
import 'package:church_platform/utils//SharedPreferencesUtils.dart';
import 'package:church_platform/utils/ValidateUtils.dart';
import 'package:church_platform/views/lordday/LorddayInfoMainWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';


class ModifyUsernameWidget extends StatefulWidget {
  CustomUser user;
  ModifyUsernameWidget({Key key, this.user}) : super(key: key);

  @override
  _ModifyUsernameWidgetState createState() => _ModifyUsernameWidgetState();
}


class _ModifyUsernameWidgetState extends State<ModifyUsernameWidget> {
  bool _loading = false;
  String errmsg;
  String username;

  @override
  void initState() {
    super.initState();

    fetch();
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
      return ListView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            maxLength: 30,
//            autofocus: true,
            initialValue:widget.user.username,
            decoration: InputDecoration(
                hintText: '请输入用户名',
                labelText: '用户名'
            ),
            validator: ValidateUsername,
            onChanged: (text) {
              username = text;
            },
            onSaved: (String value) => username = value,
          ),
          Container(
//            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  try{
                    FocusScope.of(context).requestFocus(FocusNode());
                    CustomUser u = await API().updateUserInfo(username);
                    widget.user.username = u.username;

                    setState(() {
                      _loading = false;
                    });

                    showToast(
                        "修改成功",
                        duration: Duration(seconds: 2),
                        position: ToastPosition.center,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        radius: 13.0,
                        textStyle: TextStyle(fontSize: 18.0),
                        onDismiss: (){
                          Navigator.pop(context,widget.user.username);
                        }
                    );

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



                },
                child: Text('修改',style: TextStyle(color: Colors.white)),
                color: Theme.of(context).buttonColor
            ),
            margin: new EdgeInsets.only(
                top: 20.0
            ),
          )
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,widget.user.username);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('修改用户名'),
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
      ),
    );
  }}
