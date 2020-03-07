import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/net/models/Medias.dart';
import 'package:church_platform/net/models/Speaker.dart';

class LorddayInfoResponse {
  String errCode;
  String errMsg;
  Sermon data;

  LorddayInfoResponse({this.errCode,this.errMsg, this.data});

  LorddayInfoResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    data = json['data'] != null ? new Sermon.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Sermon {
  int id;
  Church church;
  int user;
  String title;
  Speaker speaker;
  String scripture;
//  int series;
  List<Medias> medias;
  String createTime;
  String updateTime;
  String pubTime;
  int status;

  Sermon(
      {this.id,
        this.church,
        this.user,
        this.title,
        this.speaker,
        this.scripture,
//        this.series,
        this.medias,
        this.createTime,
        this.updateTime,
        this.pubTime,
        this.status});

  Sermon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church =
    json['church'] != null ? new Church.fromJson(json['church']) : null;
    user = json['user'];
    title = json['title'];
    speaker =
    json['speaker'] != null ? new Speaker.fromJson(json['speaker']) : null;
    scripture = json['scripture'];
//    series = json['series'];
    if (json['medias'] != null) {
      medias = new List<Medias>();
      json['medias'].forEach((v) {
        medias.add(new Medias.fromJson(v));
      });
    }
    createTime = json['create_time'];
    updateTime = json['update_time'];
    pubTime = json['pub_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.church != null) {
      data['church'] = this.church.toJson();
    }
    data['user'] = this.user;
    data['title'] = this.title;
    if (this.speaker != null) {
      data['speaker'] = this.speaker.toJson();
    }
    data['scripture'] = this.scripture;
//    data['series'] = this.series;
    if (this.medias != null) {
      data['medias'] = this.medias.map((v) => v.toJson()).toList();
    }
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['pub_time'] = this.pubTime;
    data['status'] = this.status;
    return data;
  }
}
