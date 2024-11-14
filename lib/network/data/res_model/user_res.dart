///{
//   "name": "JohnDoe",
//   "email": "JohnDoe",
//   "sex": "Man",
//   "birthDate": "1990-01-01T00:00:00.000Z",
//   "deviceToken": "21312dqefsw22efff",
//   "deviceID": "dhyujhh7682",
//   "zodiac": "string",
//   "timeNotice": "1990-01-01T00:00:00.000Z",
//   "isNotice": true,
//   "point": 0,
//   "country": "Vietnam"
// }

class UserRes {
  final int? id;
  final String? name;
  final String? email;
  final String? sex;
  final DateTime? birthDate;
  final String? deviceToken;
  final String? deviceID;
  final String? zodiac;
  final DateTime? timeNotice;
  final bool? isNotice;
  final int? point;
  final String? country;

  UserRes({
    this.id,
    this.name,
    this.email,
    this.sex,
    this.birthDate,
    this.deviceToken,
    this.deviceID,
    this.zodiac,
    this.timeNotice,
    this.isNotice,
    this.point,
    this.country,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) {
    return UserRes(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sex: json['sex'],
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])?.toLocal()
          : null,
      deviceToken: json['deviceToken'],
      deviceID: json['deviceID'],
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
    return {
      'id': id,
      'name': name,
      'email': email,
      'sex': sex,
      'birthDate': birthDate?.toIso8601String(),
      'deviceToken': deviceToken,
      'deviceID': deviceID,
      'zodiac': zodiac,
      'timeNotice': timeNotice?.toIso8601String(),
      'isNotice': isNotice,
      'point': point,
      'country': country,
    };
  }
}
