class NetConfigure {
  //测试环境Ø
//  static final String HOST_NAME = "192.168.43.196:8000";
  static final String HOST_NAME = "192.168.0.102:8000";
//  static final String HOST_NAME = "test.l3.bicf.org";

//  static final String HOST_NAME = "13.231.255.163";//"""http://l3.community";
  static final String HOST = "http://" + HOST_NAME; //"""http://l3.community";
  static final String APIS = "/rapi";
}

class NetAPI {
  String subApi;

  NetAPI(String subApi) {
    this.subApi = subApi;
  }

  String get fullPath {
    return NetConfigure.HOST + NetConfigure.APIS + subApi;
  }

  String get host {
    return NetConfigure.HOST;
  }

  String get host_name{
    return NetConfigure.HOST_NAME;
  }

  String get relativePath {
    return NetConfigure.APIS + subApi;
  }
}

enum NetMethod { GET, POST }