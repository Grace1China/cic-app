import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:church_platform/utils//SharedPreferencesUtils.dart';
import 'package:church_platform/main.dart';


class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}


class _AccountWidgetState extends State<AccountWidget> {
//  Future<Post> post;

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: Stack(
                  children: <Widget>[
                    Center(child: Icon(Icons.account_circle,size: 70,),),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                '名称:',
//              softWrap: true,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("Daniel",style: TextStyle(fontSize: 14),),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '性别:',
//              softWrap: true,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("男",style: TextStyle(fontSize: 14),),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '生日:',
//              softWrap: true,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("2月22日",style: TextStyle(fontSize: 14),),
            ],
          ),
          Row(
            children: <Widget>[

              FlatButton(child: Text("登出"),
                color: Theme.of(context).buttonColor, onPressed: (){
                  SharedPreferencesUtils.logout();
                  MyApp.myTabbedPageKey.currentState.changeIndex(4);
                  Navigator.of(context).pop();
              },),
            ],
          )
        ],
      ),
    );
  }
}
