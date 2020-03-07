// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'One';
  List<String> options = <String>['One', 'Two', 'Free', 'Four'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
//      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
//      underline: Container(
//        height: 0,
//        color: Colors.deepPurpleAccent,
//      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
    selectedItemBuilder: (BuildContext context) {
      return options.map((String value) {
        return Text(
          dropdownValue,
          style: TextStyle(color: Colors.white),
        );
      }).toList();
    },
      items: options
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: dropdownValue == value ? TextStyle(color: Colors.amber) : TextStyle(color: Colors.green),),
        );
      }).toList(),
    );
  }


//   @override
//   Widget build(BuildContext context){
//     return Container(
//       alignment: Alignment.center,
//       color: Colors.white,
//       child: DropdownButton<String>(
//         value: dropdownValue,
//         onChanged: (String newValue) {
//           setState(() {
//             dropdownValue = newValue;
//           });
//         },
//         style: TextStyle(color: Colors.blue),
//         selectedItemBuilder: (BuildContext context) {
//           return options.map((String value) {
//             return Text(
//               dropdownValue,
//               style: TextStyle(color: Colors.white),
//             );
//           }).toList();
//         },
//         items: options.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//       ),
//     );
//   }
}