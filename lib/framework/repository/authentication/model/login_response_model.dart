
class LoginData {
  LoginData({
    this.token,
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.profileImage,
    this.country,
    this.mobileVerified,
    this.profileVerified,
    this.isPremiumUser,
    this.enableNotification,
    this.enableSms,
    this.enableEmail,
    this.isSocialLogin,
    this.userType,
  });

  String? token;
  String? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? profileImage;
  Country? country;
  String? mobileVerified;
  String? profileVerified;
  String? isPremiumUser;
  String? enableNotification;
  String? enableSms;
  String? enableEmail;
  String? isSocialLogin;
  String? userType;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    token: json['token'],
    id: json['id'],
    name: json['name'],
    email: json['email'],
    mobileNumber: json['mobile_number'],
    profileImage: json['profile_image'],
    country: json['country'] == null ? null : Country.fromJson(json['country']),
    mobileVerified: json['mobile_verified'],
    profileVerified: json['profile_verified'],
    isPremiumUser: json['is_premium_user'],
    enableNotification: json['enable_notification'],
    enableSms: json['enable_sms'],
    enableEmail: json['enable_email'],
    isSocialLogin: json['is_social_login'],
    userType: json['user_type'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'id': id,
    'name': name,
    'email': email,
    'mobile_number': mobileNumber,
    'profile_image': profileImage,
    'country': country == null ? null : country!.toJson(),
    'mobile_verified': mobileVerified,
    'profile_verified': profileVerified,
    'is_premium_user': isPremiumUser,
    'enable_notification': enableNotification,
    'enable_sms': enableSms,
    'enable_email': enableEmail,
    'is_social_login': isSocialLogin,
    'user_type': userType,
  };
}

class Country {
  Country({
    this.id,
    this.name,
    this.code,
    this.flag,
  });

  String? id;
  String? name;
  String? code;
  String? flag;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json['id'],
    name: json['name'],
    code: json['code'],
    flag: json['flag'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'flag': flag,
  };
}
