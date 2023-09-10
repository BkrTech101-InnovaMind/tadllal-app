class SignInSignUpRequest {
  late String? name;
  late String? email;
  late String? password;
  late String? passwordConfirmation;
  late String? deviceName = "";

  SignInSignUpRequest({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.deviceName = "mobile",
  }) : assert(
          (email != null && password != null) || (deviceName != null),
        );

  SignInSignUpRequest.fromJson(Map<String, dynamic> json) {
    name = json["name"] ?? "";
    email = json['email'];
    password = json['password'];
    passwordConfirmation = json["password_confirmation"] ?? json['password'];
    deviceName = json['device_name'] ?? "mobile";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name ?? "";
    data['email'] = email;
    data['password'] = password;
    data["password_confirmation"] = passwordConfirmation ?? password;
    data['device_name'] = deviceName ?? "mobile";

    return data;
  }
}
