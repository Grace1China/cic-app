import 'dart:ffi';

class Course {
//  const Sunday({this.name});
  final String name;
  final int id;

  final String title; //只夸基督十架",
  final String cover; //:"35",
  final String preacher; //李牧师",
  final String datetime;//"2019-11-03 11:30am"
  final String video;
  final double price;
  final String currency;
  final int saled_amount;
  final int status;

  Course(this.name, this.id, this.title, this.cover, this.preacher,
      this.datetime, this.video, this.price, this.currency, this.saled_amount,
      this.status);


}