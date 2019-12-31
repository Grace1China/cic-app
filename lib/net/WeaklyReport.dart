
class BaseResponse {
  String errCode;
  String errMsg;
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

//class ResponeResult{
//
//  ResponeResult.fromJson(Map<String, dynamic> json);
//
//  ResponeResult();
//}

class WeaklyReport{
  int id;
  int church;
  int creator;
  String title;
  String image;
  String content;
  int status;
  String pub_time;
  String create_time;
  String update_time;

  WeaklyReport(
      {this.id,
        this.church,
        this.creator,
        this.title,
        this.image,
        this.content,
        this.status,
        this.pub_time,
        this.create_time,
        this.update_time});

  WeaklyReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church = json['church'];
    creator = json['creator'];
    title = json['title'];
    image = json['image'];
    content = json['content'];
    status = json['status'];
    pub_time = json['pub_time'];
    create_time = json['create_time'];
    update_time = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['church'] = this.church;
    data['creator'] = this.creator;
    data['title'] = this.title;
    data['image'] = this.image;
    data['content'] = this.content;
    data['status'] = this.status;
    data['pub_time'] = this.pub_time;
    data['create_time'] = this.create_time;
    data['update_time'] = this.update_time;
    return data;
  }
}
