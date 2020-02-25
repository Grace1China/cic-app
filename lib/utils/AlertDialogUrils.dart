import 'package:flutter/material.dart';

class AlertDialogUtils{

  static void show(BuildContext context,{String title,String content,bool canCancel = false,String okTitle = "确定",VoidCallback okHandler}){
    List<Widget> actions = List<Widget>();
    if(canCancel){
      actions.add(FlatButton(child: Text('取消'), onPressed: () {
        Navigator.pop(context);
      }));
    }
    String oktext = "确定";
    if(okTitle != null && okTitle != ""){
      oktext = okTitle;
    }
    actions.add(FlatButton(child: Text(oktext), onPressed: () {
      Navigator.pop(context);
      if(okHandler != null){
        okHandler();
      }
    }));

    showDialog(
        context:context,
        barrierDismissible:false,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text(title, textScaleFactor: 1),
            content: Text(content, textScaleFactor: 1),
            actions: actions,
          );
        }
    );
  }


  static Future<bool> showAwaitWithHandler(BuildContext context,String title,String content, VoidCallback okHandler) async{
    showDialog(
        context:context,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text(title, textScaleFactor: 1),
            content: Text(content, textScaleFactor: 1),
            actions: <Widget>[
              FlatButton(child: Text('取消'), onPressed: () {
                Navigator.pop(context);
                return Future<bool>.value(false);
              }),
              FlatButton(child: Text('确定'), onPressed: () {
                Navigator.pop(context);
                okHandler();
                return Future<bool>.value(true);
              }),
            ],
          );
        }
    );
  }
}