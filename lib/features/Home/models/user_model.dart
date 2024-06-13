class UserModel {
  String? gender;
  Name? name;
  String? email;
  Dob? dob;
  String? phone;
  Picture? picture;
  String? nat;

  UserModel({gender, name, location, email, login, dob, registered, phone, cell, id, picture, nat});

  UserModel.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    email = json['email'];
    dob = json['dob'] != null ? Dob.fromJson(json['dob']) : null;
    phone = json['phone'];
    picture = json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    nat = json['nat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    data['email'] = email;
    if (dob != null) {
      data['dob'] = dob!.toJson();
    }
    data['phone'] = phone;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    data['nat'] = nat;
    return data;
  }
}

class Name {
  String? title;
  String? first;
  String? last;

  Name({title, first, last});

  Name.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['first'] = first;
    data['last'] = last;
    return data;
  }
}

class Dob {
  String? date;
  int? age;

  Dob({date, age});

  Dob.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['age'] = age;
    return data;
  }
}


class Picture {
  String? large;
  String? medium;
  String? thumbnail;

  Picture({large, medium, thumbnail});

  Picture.fromJson(Map<String, dynamic> json) {
    large = json['large'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['large'] = large;
    data['medium'] = medium;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
