
// To parse this JSON data, do
//
//     final modelUpdateProfile = modelUpdateProfileFromJson(jsonString);

import 'dart:convert';

ModelProfile modelProfileFromJson(String str) => ModelProfile.fromJson(json.decode(str));

String modelProfileToJson(ModelProfile data) => json.encode(data.toJson());

class ModelProfile {
  bool isSuccess;
  int value;
  String message;

  ModelProfile({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelProfile.fromJson(Map<String, dynamic> json) => ModelProfile(
    isSuccess: json["is_success"],
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "value": value,
    "message": message,
  };
}
