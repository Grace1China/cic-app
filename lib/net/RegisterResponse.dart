class RegisterResponse {
  int id;
  String user;
  String description;
  String location;
  int role;
  String dateJoined;
  String updatedOn;
  int church;

  RegisterResponse(
      {this.id,
        this.user,
        this.description,
        this.location,
        this.role,
        this.dateJoined,
        this.updatedOn,
        this.church});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    description = json['description'];
    location = json['location'];
    role = json['role'];
    dateJoined = json['date_joined'];
    updatedOn = json['updated_on'];
    church = json['church'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['description'] = this.description;
    data['location'] = this.location;
    data['role'] = this.role;
    data['date_joined'] = this.dateJoined;
    data['updated_on'] = this.updatedOn;
    data['church'] = this.church;
    return data;
  }
}