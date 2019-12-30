class LorddayInfoResponse {
  String errCode;
  LorddayInfo data;

  LorddayInfoResponse({this.errCode, this.data});

  LorddayInfoResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new LorddayInfo.fromJson(json['data']) : null;
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

class LorddayInfo {
  int id;
  ChurchInLordday church;
  int user;
  String title;
  Speaker speaker;
  String scripture;
  int series;
  List<Medias> medias;
  String createTime;
  String updateTime;
  String pubTime;
  int status;

  LorddayInfo(
      {this.id,
        this.church,
        this.user,
        this.title,
        this.speaker,
        this.scripture,
        this.series,
        this.medias,
        this.createTime,
        this.updateTime,
        this.pubTime,
        this.status});

  LorddayInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church =
    json['church'] != null ? new ChurchInLordday.fromJson(json['church']) : null;
    user = json['user'];
    title = json['title'];
    speaker =
    json['speaker'] != null ? new Speaker.fromJson(json['speaker']) : null;
    scripture = json['scripture'];
    series = json['series'];
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
    data['series'] = this.series;
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

class ChurchInLordday {
  int id;
  String name;
  String code;
  List<Venue> venue;
  String description;
  String promotCover;
  String promotVideo;

  ChurchInLordday(
      {this.id,
        this.name,
        this.code,
        this.venue,
        this.description,
        this.promotCover,
        this.promotVideo});

  ChurchInLordday.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Venue {
  int id;
  String time;
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

class Speaker {
  int id;
  String name;
  String title;
  String introduction;
  String createTime;
  String updateTime;
  Null church;

  Speaker(
      {this.id,
        this.name,
        this.title,
        this.introduction,
        this.createTime,
        this.updateTime,
        this.church});

  Speaker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    introduction = json['introduction'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    church = json['church'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['introduction'] = this.introduction;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['church'] = this.church;
    return data;
  }
}

//MEDIA_WORSHIP = 1
//MEDIA_MC = 2
//MEDIA_SERMON = 3
//MEDIA_GIVING = 4
//MEDIA_OTHER = 5
enum MediaType {
  warship,
  mc,
  sermon,
  giving,
  other,
}

String MediaTypeToName(MediaType type){
  switch(type){
    case MediaType.warship: return "敬拜";
    case MediaType.mc: return "主持";
    case MediaType.sermon: return "讲道";
    case MediaType.giving: return "奉献";
    case MediaType.other: return "其他";
    default: return "其他";
  }
}

MediaType MediaTypeFromInt(int i){
  switch(i){
    case 1: return MediaType.warship;
    case 2: return MediaType.mc;
    case 3: return MediaType.sermon;
    case 4: return MediaType.giving;
    case 5: return MediaType.other;
  }
  return MediaType.other;
}


class Medias {
  int owner;
  int kind;
  String title;
  String video;
  int videoStatus;
  String sHDURL;
  String hDURL;
  String sDURL;
  String audio;
  String image;
  String imagePresignedUrl;
  String pdfPresignedUrl;
  String pdf;
  String content;

  Medias(
      {this.owner,
        this.kind,
        this.title,
        this.video,
        this.videoStatus,
        this.sHDURL,
        this.hDURL,
        this.sDURL,
        this.audio,
        this.image,
        this.imagePresignedUrl,
        this.pdfPresignedUrl,
        this.pdf,
        this.content});

  Medias.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    kind = json['kind'];
    title = json['title'];
    video = json['video'];
    videoStatus = json['video_status'];
    sHDURL = json['SHD_URL'];
    hDURL = json['HD_URL'];
    sDURL = json['SD_URL'];
    audio = json['audio'];
    image = json['image'];
    imagePresignedUrl = json['image_presigned_url'];
    pdfPresignedUrl = json['pdf_presigned_url'];
    pdf = json['pdf'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['kind'] = this.kind;
    data['title'] = this.title;
    data['video'] = this.video;
    data['video_status'] = this.videoStatus;
    data['SHD_URL'] = this.sHDURL;
    data['HD_URL'] = this.hDURL;
    data['SD_URL'] = this.sDURL;
    data['audio'] = this.audio;
    data['image'] = this.image;
    data['image_presigned_url'] = this.imagePresignedUrl;
    data['pdf_presigned_url'] = this.pdfPresignedUrl;
    data['pdf'] = this.pdf;
    data['content'] = this.content;
    return data;
  }
}
