
class Speaker {
  int id;
  String name;
  String title;
  String introduction;
  String createTime;
  String updateTime;
  String church;

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
