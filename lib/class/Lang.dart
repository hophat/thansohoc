import 'dart:async';
import 'dart:ui';

class Lang {
  Lang(this.key, this.lable, this.country);
  final String key;
  final String lable;
  final String country;
}

StreamController<String> langSteamController = StreamController<String>();

final List<Lang> defaultLangs = <Lang>[
  Lang('en', "English", "US"),
  Lang('vi', "Tiếng Việt", "VietNam"), // vn
  // Lang('ru', "русский язык"),// nga
  // // Lang('lo', "ພາສາລາວ"), // lào
  Lang('hi', "Hindi", "Hindi"), // Ấn
  // Lang('fr', "français"), // pháp
  // Lang('zh', "中国"), // pháp
  // Lang('id', "Indonesian"), // indonesia
  // Lang('pt', "Portuguese"), // bo đầu nha
];