import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/gender_enum.dart';
import 'package:flutter_app_than_so_hoc_2/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReq {
  final String? name;
  final String? email;
  final Gender sex;
  final DateTime? birthDate;
  final String? deviceToken;
  // final String? deviceID;
  final String? zodiac;
  final DateTime? timeNotice;
  final bool? isNotice;
  final int? point;
  final String? country;

  const UserReq({
    this.name,
    this.email,
    this.sex = Gender.other,
    this.birthDate,
    this.deviceToken,
    // this.deviceID,
    this.zodiac,
    this.timeNotice,
    this.isNotice,
    this.point,
    this.country,
  });

  factory UserReq.fromJson(Map<String, dynamic> json) {
    return UserReq(
      name: json['name'],
      email: json['email'],
      sex: Gender.fromString(json['sex']),
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])?.toLocal()
          : null,
      deviceToken: json['deviceToken'],
      // deviceID: json['deviceID'],
      zodiac: json['zodiac'],
      timeNotice: json['timeNotice'] != null
          ? DateTime.tryParse(json['timeNotice'])?.toLocal()
          : null,
      isNotice: json['isNotice'],
      point: json['point'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    final m = {
      'name': (name??'').isNotEmpty ? name : 'user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'sex': sex.v,
      'birthDate': birthDate?.toUtc().toString(),
      'deviceToken': deviceToken,
      'deviceID': getIt.get<SharedPreferences>().getString(deviceIDKey),
      'zodiac': zodiac,
      'timeNotice': timeNotice?.toUtc().toString(),
      // 'isNotice': isNotice,
      'point': point,
      'country': country,
    };
    m.removeWhere((key, value) => value == null || (value is String && value.isEmpty));
    print('UserReq.toJson: $m');
    return m;
  }

  @override
  String toString() {
    return 'UserReq{name: $name, email: $email, sex: $sex, birthDate: $birthDate, deviceToken: $deviceToken, zodiac: $zodiac, timeNotice: $timeNotice, isNotice: $isNotice, point: $point, country: $country}';
  }
}