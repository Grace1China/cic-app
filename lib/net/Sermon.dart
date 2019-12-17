
import 'package:church_platform/views/sermon/SermonShowWidget.dart';

class BaseResponse2 {
  String errCode;
  Sermon data;

  BaseResponse2({this.errCode, this.data});

  BaseResponse2.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new Sermon.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Sermon {
  int id;
  int church;
  int user;
  String title;
  String date;
  String description;
  String pdf;
  int speaker;
  String scripture;
  int series;
  String cover;
  String worshipvideo;
  String mcvideo;
  String sermonvideo;
  String givingvideo;
  int status;

  Sermon(
      {this.id,
        this.church,
        this.user,
        this.title,
        this.date,
        this.description,
        this.pdf,
        this.speaker,
        this.scripture,
        this.series,
        this.cover,
        this.worshipvideo,
        this.mcvideo,
        this.sermonvideo,
        this.givingvideo,
        this.status});

  List<SermonType> canShowTypes(){
    var list = List<SermonType>();
//    if(worshipvideo != null){
//      list.add(SermonType.warship);
//    }
//    if(mcvideo != null){
//      list.add(SermonType.mc);
//    }
//    if(SermonType.sermon != null){
//      list.add(SermonType.sermon);
//    }
//    if(givingvideo != null){
//      list.add(SermonType.giving);
//    }

    list.add(SermonType.warship);
    list.add(SermonType.mc);
    list.add(SermonType.sermon);
    list.add(SermonType.giving);

    return list;
  }

  String getUrl(SermonType type){
    switch(type){
      case SermonType.warship:{
        return "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        return worshipvideo;
      }
      case SermonType.mc:{
        return 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
        return mcvideo;
      }
      case SermonType.sermon:
        {

          return sermonvideo;
        }
      case SermonType.giving:{
        return "http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8";
        return givingvideo;
      }
    }
    return sermonvideo;
  }

  Sermon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church = json['church'];
    user = json['user'];
    title = json['title'];
    date = json['date'];
    description = json['description'];
    pdf = json['pdf'];
    speaker = json['speaker'];
    scripture = json['scripture'];
    series = json['series'];
    cover = json['cover'];
    worshipvideo = json['worshipvideo'];
    mcvideo = json['mcvideo'];
    sermonvideo = json['sermonvideo'];
    givingvideo = json['givingvideo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['church'] = this.church;
    data['user'] = this.user;
    data['title'] = this.title;
    data['date'] = this.date;
    data['description'] = this.description;
    data['pdf'] = this.pdf;
    data['speaker'] = this.speaker;
    data['scripture'] = this.scripture;
    data['series'] = this.series;
    data['cover'] = this.cover;
    data['worshipvideo'] = this.worshipvideo;
    data['mcvideo'] = this.mcvideo;
    data['sermonvideo'] = this.sermonvideo;
    data['givingvideo'] = this.givingvideo;
    data['status'] = this.status;
    return data;
  }
}