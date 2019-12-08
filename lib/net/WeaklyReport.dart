
class BaseResponse {
  String errCode;
  WeaklyReport data;

  BaseResponse({this.errCode, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new WeaklyReport.fromJson(json['data']) : null;
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

class WeaklyReport {
  int id;
  int church;
  int user;
  String title;
  String image;
  String content;
  int status;
  String pubTime;
  String createTime;
  String updateTime;

  WeaklyReport(
      {this.id,
        this.church,
        this.user,
        this.title,
        this.image,
        this.content,
        this.status,
        this.pubTime,
        this.createTime,
        this.updateTime});

  WeaklyReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church = json['church'];
    user = json['user'];
    title = json['title'];
    image = json['image'];
    content = json['content'];
    status = json['status'];
    pubTime = json['pub_time'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['church'] = this.church;
    data['user'] = this.user;
    data['title'] = this.title;
    data['image'] = this.image;
    data['content'] = this.content;
    data['status'] = this.status;
    data['pub_time'] = this.pubTime;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    return data;
  }
}
