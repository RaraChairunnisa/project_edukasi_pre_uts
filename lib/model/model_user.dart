
// To parse this JSON data, do
//
//     final modelUsers = modelUsersFromJson(jsonString);

import 'dart:convert';

ModelUsers modelUsersFromJson(String str) => ModelUsers.fromJson(json.decode(str));

String modelUsersToJson(ModelUsers data) => json.encode(data.toJson());

class ModelUsers {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelUsers({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelUsers.fromJson(Map<String, dynamic> json) => ModelUsers(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String nama;
  String username;
  String password;
  String email;
  String nohp;

  Datum({
    required this.id,
    required this.nama,
    required this.username,
    required this.password,
    required this.email,
    required this.nohp,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nama: json["nama"],
    username: json["username"],
    password: json["password"],
    email: json["email"],
    nohp: json["nohp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "username": username,
    "password": password,
    "email": email,
    "nohp": nohp,
  };
}
