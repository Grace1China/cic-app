import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/utils/ToasterUtils.dart';
import 'package:church_platform/utils/ValidateUtils.dart';
import 'package:church_platform/views/account/RegisterWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'package:church_platform/utils/CPTheme.dart';


class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = '登录';

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

  Widget _buildWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '请输入邮箱',
                labelText: '邮箱'
            ),
            validator: ValidateEmail,
            onChanged: (text) {
              _data.email = text;
            },
            onSaved: (String value) => _data.email = value,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
//              border: InputBorder.none,
                hintText: '请输入密码',
                labelText: '密码'
            ),
            validator:ValidatePWD,
            controller: myController,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      _saving = true;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());

//                    new Future.delayed(new Duration(seconds: 4), () {
//                      setState(() {
//                        _saving = false;
//                      });
//                    });

                    try{
                      String token = await API().login(_data.email, myController.text);

                      setState(() {
                        _saving = false;
                      });

                      if(token != null){
                        ToasterUtils.show(context,msg: "登录成功",onDismiss: (){
                          HomeTabBarWidget.myTabbedPageKey.currentState.loginSuccess();
                        });

//                      Fluttertoast.showToast(
//                            msg: "登录成功",
//                            toastLength: Toast.LENGTH_SHORT,
//                            gravity: ToastGravity.CENTER,
//                            timeInSecForIos: 1,
//                            backgroundColor: Colors.grey,
//                            textColor: Colors.white,
//                            fontSize: 16.0
//                        );
                      }else{
                        ToasterUtils.show(context,msg: "登录失败");
                      }
                    }catch (e){
                      setState(() {
                        _saving = false;
                      });

                      ToasterUtils.show(context,msg: e.toString());
                    }

//                        showDialog(
//                          context: context,
//                          builder: (context) {
//                            return AlertDialog(
//                              // Retrieve the text the that user has entered by using the
//                              // TextEditingController.
//                              content: Text("正在登录..."),
//                            );
//                          },
//                        );




//
//                        showToastWidget(Container(
//                                            padding: EdgeInsets.all(0),
//                                            child: Text("正在登录...",style: TextStyle(fontSize: 18),),) ,
//                            duration: Duration(seconds: 5),);

//                        String token = await API().login(_data.username, myController.text);
//                        if(token != null){
//                          Navigator.of(context).pop();
//                        }else{
//
//                        }


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


//                        Timer(Duration(seconds: 3), () {
//                          print("Yeah, this line is printed after 3 seconds");
//                          SharedPreferencesUtils.saveIsLogin();
//                          Navigator.of(context).pop();
//                        });

                  }else{

                  }
                },
                child: Text('登录',
                    style: TextStyle(
                        color: Colors.white)),
                color: ThemeButtonColor,
            ),
            margin: new EdgeInsets.only(
                top: 20.0
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new RegisterWidget(),
                    ),
                  );
                },
                child: Text('还没有账户？去注册',
                    style: new TextStyle(
                        color: ThemeButtonColor)),
//                color: Colors.white
            ),
//            margin: new EdgeInsets.only(
//                top: 20.0
//            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ModalProgressHUD(child:  Container(
      padding: EdgeInsets.all(20.0),
        child:  _buildWidget()
    ),inAsyncCall:_saving ,);
  }
}

