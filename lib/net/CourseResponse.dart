import 'package:church_platform/net/ChurchResponse.dart';
import 'package:church_platform/net/LorddayInfoResponse.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/net/models/Medias.dart';
import 'package:church_platform/net/models/Speaker.dart';

class CourseResponse {
  String errCode;
  String errMsg;
  List<Course> data;
  int page;
  int totalPage;

  CourseResponse({this.errCode, this.errMsg,this.data, this.page, this.totalPage});

  CourseResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    if (json['data'] != null) {
      data = new List<Course>();
      json['data'].forEach((v) {
        data.add(new Course.fromJson(v));
      });
    }
    page = json['page'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['totalPage'] = this.totalPage;
    return data;
  }
}

class Course {
  int id;
  Church church;
//  Speaker speaker;
  String title;
  String description;
  String content;
  String price;
  List<Medias> medias;
  String createTime;
  String updateTime;

  Course(
      {this.id,
        this.church,
//        this.speaker,
        this.title,
        this.description,
        this.content,
        this.price,
        this.medias,
        this.createTime,
        this.updateTime});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church =
    json['church'] != null ? new Church.fromJson(json['church']) : null;
//    speaker =
//    json['speaker'] != null ? new Speaker.fromJson(json['speaker']) : null;
    title = json['title'];
    description = json['description'];
    content = json['content'];
    price = json['price'];
    if (json['medias'] != null) {
      medias = new List<Medias>();
      json['medias'].forEach((v) {
        medias.add(new Medias.fromJson(v));
      });
    }
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.church != null) {
      data['church'] = this.church.toJson();
    }
//    if (this.speaker != null) {
//      data['speaker'] = this.speaker.toJson();
//    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['price'] = this.price;
    if (this.medias != null) {
      data['medias'] = this.medias.map((v) => v.toJson()).toList();
    }
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    return data;
  }
}
