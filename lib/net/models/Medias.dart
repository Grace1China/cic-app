
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
