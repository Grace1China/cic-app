import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/main.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/CustomUser.dart';
import 'package:church_platform/utils//SharedPreferencesUtils.dart';
import 'package:church_platform/views/account/ModifyUsernameWidget.dart';
import 'package:church_platform/views/account/ModifyPWDWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}


class _AccountWidgetState extends State<AccountWidget> {
  CustomUser user;
  bool isloading = true;
  String errmsg;

  @override
  void initState() {
    super.initState();

    fetch();
  }

  void fetch() async{
    try {
      user = await API().getUserInfo();
      setState(() {
        errmsg = null;
        isloading = false;
      });
    }catch(e){
      setState((){
        errmsg = e.toString();
        isloading = false;
        user = null;
      });
    }
  }

Widget buildAvatarAndName(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 80,
        height: 80,
        child: Stack(
          children: <Widget>[
            Center(child: Icon(Icons.account_circle, size: 70,),),
            Center(child:
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/250?image=9',
                    ),
                    fit: BoxFit.cover
                ),
              ),
            )
            ),

//                    Center(
//                      child: FadeInImage.memoryNetwork(
//                        placeholder: kTransparentImage,
//                        image: 'https://picsum.photos/250?image=9',
//                      ),
//                    ),
          ],
        ),

      ),
      SizedBox(width: 10),
      Text(
        'Daniel',
//              softWrap: true,
        style: Theme.of(context).textTheme.subhead,
      ),
    ],
  );
}


  Widget _myListView(BuildContext context) {

    final titles = ['bike', 'boat', 'bus', 'car',
      'railway', 'run', 'subway', 'transit', 'walk'];

    final icons = [Icons.email, Icons.title,
      Icons.directions_bus, Icons.directions_car, Icons.directions_railway,
      Icons.directions_run, Icons.directions_subway, Icons.directions_transit,
      Icons.directions_walk];

    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(titles[index]),
            trailing: Icon(Icons.keyboard_arrow_right),

        );
      },
    );
  }

Widget buildContent(BuildContext context) {
  if (isloading) {
    return Center(child: CircularProgressIndicator());
  } else if (errmsg != null && errmsg.isNotEmpty) {
    return Text(errmsg);
  } else {
//    return _myListView(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Row(
            children: <Widget>[
              Text(
                '邮    箱：',
//              softWrap: true,
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(width: 10),
              Text(user.email),
            ],
          ),
        ),
        Container(padding:EdgeInsets.only(left:8),child: Divider(color: Colors.grey,)),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
          child: Row(
            children: <Widget>[
              Text(
                '用户名：',
//              softWrap: true,
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(width: 10),
              Text(user.username),
            ],
          ),
        ),
//        Container(padding:EdgeInsets.only(left:0),child: Divider(color: Colors.grey,)),
        Container(
          height: 10,
          color: Colors.black12,
        ),
        GestureDetector(
          child:Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            color: Theme.of(context).scaffoldBackgroundColor, //写上颜色才能点击Spacer()。
            child: Row(
              children: <Widget>[
                Text(
                  '修改用户名',
//              softWrap: true,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right),
                SizedBox(width:8),
              ],
            ),
          ),
          onTap: () async{
//              Navigator.of(context).push(CupertinoPageRoute(
//                  fullscreenDialog: true,
//                  builder: (context) => AccountWidget()));
            String username = await Navigator.push(context,MaterialPageRoute(
              builder: (context) => ModifyUsernameWidget(user: user,),)
            );
            if(user.username != username){
              setState(() {
                user.username = username;
              });
            }

          },
        ),
        Container(padding:EdgeInsets.only(left:8),child: Divider(color: Colors.grey,)),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            color: Theme.of(context).scaffoldBackgroundColor, //写上白色才能点击Spacer()。
            child: Row(
              children: <Widget>[
                Text(
                  '修改密码',
//              softWrap: true,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right),
                SizedBox(width:8),
              ],
            ),
          ),
          onTap: () async{
            Navigator.push(context,MaterialPageRoute(
              builder: (context) => ModifyPWDWidget(user: user,),)
            );
          },
        ),
        Container(padding:EdgeInsets.only(left:0),child: Divider(color: Colors.grey,)),
//        Container(
//          height: 10,
//          color: Colors.black12,
//        ),
        Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
              onPressed: () async {
                HomeTabBarWidget.myTabbedPageKey.currentState.logoutSuccess();
              },
              child: Text('登出',style: TextStyle(color: Colors.white)),
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
  return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
        //centerTitle: true,
        elevation:
        (Theme
            .of(context)
            .platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: buildContent(context)
  );
}}
