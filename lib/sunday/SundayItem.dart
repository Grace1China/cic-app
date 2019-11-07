import 'package:church_platform/sunday/Sunday.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

typedef void SundayOnTapCallback(Sunday sunday);

class SundayItem extends StatelessWidget {
  SundayItem({Sunday sundy,  this.onTaped})
      : sundy = sundy,
        super(key: ObjectKey(sundy));

  final Sunday sundy;
  final SundayOnTapCallback onTaped;

  Color _getColor(BuildContext context) {
    return Theme.of(context).secondaryHeaderColor; //Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).primaryColor,
//      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTaped(sundy);
      },
//      leading:Stack(
//        alignment: AlignmentDirectional.center,
//        children: <Widget>[
//          Center(child: CircularProgressIndicator()),
//          Center(
//            child: FadeInImage.memoryNetwork(
//              placeholder: kTransparentImage,
//              image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
////                  width: 600,
////                  height: 240,
////                  fit: BoxFit.cover,
//            ),
//          ),
//        ],
//      ),
        leading:FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//                  width: 600,
//                  height: 240,
//                  fit: BoxFit.cover,
            ),
//      leading: Image(
//            image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
//          ),
//      leading: CircleAvatar(
//        backgroundColor: _getColor(context),
//        child: Text(sundy.name[0]),
//      ),
      title: Text(sundy.name),
      subtitle: Text(sundy.preacher),
//      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}