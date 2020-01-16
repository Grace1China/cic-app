
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
  int kind;
  String title;
  String video;
  int videoStatus;
  String sHDURL;
  String hDURL;
  String sDURL;
  String audio;
  String image;
  String pdf;
  String content;

  Medias(
      {this.kind,
        this.title,
        this.video,
        this.videoStatus,
        this.sHDURL,
        this.hDURL,
        this.sDURL,
        this.audio,
        this.image,
        this.pdf,
        this.content});

  Medias.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    title = json['title'];
    video = json['video'];
    videoStatus = json['video_status'];
    sHDURL = json['SHD_URL'];
    hDURL = json['HD_URL'];
    sDURL = json['SD_URL'];
    audio = json['audio'];
    image = json['image'];
    pdf = json['pdf'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['title'] = this.title;
    data['video'] = this.video;
    data['video_status'] = this.videoStatus;
    data['SHD_URL'] = this.sHDURL;
    data['HD_URL'] = this.hDURL;
    data['SD_URL'] = this.sDURL;
    data['audio'] = this.audio;
    data['image'] = this.image;
    data['pdf'] = this.pdf;
    data['content'] = this.content;
    return data;
  }
}
