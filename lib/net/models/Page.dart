class NetPage {
  int page = 1;
  int pageSize = 10;
  int totalPage = 1000;

  NetPage({this.page,
        this.totalPage});

  bool hasNext(){
    return page < totalPage;
  }
//
//  Page.fromJson(Map<String, dynamic> json) {
//    page = json['page'];
//    pageSize = json['pageSize'];
//    totalPage = json['totalPage'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['page'] = this.page;
//    data['pageSize'] = this.pageSize;
//    data['totalPage'] = this.totalPage;
//    return data;
//  }
}