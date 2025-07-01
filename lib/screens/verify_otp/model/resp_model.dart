class VerifyOtpResponse {
  String? message;
  String? token;
  User? user;

  VerifyOtpResponse({
    this.message,
    this.token,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String?, dynamic> json) =>
      VerifyOtpResponse(
        message: json["message"],
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String?, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user": user!.toJson(),
      };
}

class User {
  String? uuid;
  String? contact;
  String? name;

  User({
    this.uuid,
    this.contact,
    this.name,
  });

  factory User.fromJson(Map<String?, dynamic> json) => User(
        uuid: json["uuid"],
        contact: json["contact"],
        name: json["name"],
      );

  Map<String?, dynamic> toJson() => {
        "uuid": uuid,
        "contact": contact,
        "name": name,
      };
}
