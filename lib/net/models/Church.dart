
import 'package:church_platform/net/common/NetResponse.dart';

class Church extends NetResult {
  int id;
  String name;
  String code;
  List<Venue> venue;
  String description;
  String promotCover;
  String promotVideo;
  String giving_qrcode;

  Church(
      {this.id,
        this.name,
        this.code,
        this.venue,
        this.description,
        this.promotCover,
        this.promotVideo,
        this.giving_qrcode});

  Church.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    if (json['venue'] != null) {
      venue = new List<Venue>();
      json['venue'].forEach((v) {
        venue.add(new Venue.fromJson(v));
      });
    }
    description = json['description'];
    promotCover = json['promot_cover'];
    promotVideo = json['promot_video'];
    giving_qrcode = json['giving_qrcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    if (this.venue != null) {
      data['venue'] = this.venue.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['promot_cover'] = this.promotCover;
    data['promot_video'] = this.promotVideo;
    data['giving_qrcode'] = this.giving_qrcode;
    return data;
  }
}

class Venue {
  int id;
  String time; //09:00:00
  String address;
  String addressUrl;

  Venue({this.id, this.time, this.address, this.addressUrl});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    address = json['address'];
    addressUrl = json['addressUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['address'] = this.address;
    data['addressUrl'] = this.addressUrl;
    return data;
  }
}