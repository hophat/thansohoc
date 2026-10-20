import 'dart:async';
import 'dart:ui';

class Lang {
  Lang(this.key, this.lable);
  final String key;
  final String lable;
}

StreamController<String> langSteamController = StreamController<String>();

final List<Lang> listLang = <Lang>[
  Lang('en', "English"),
  Lang('vi', "Tiếng Việt"), // vn
  // Lang('ru', "русский язык"),// nga
  // // Lang('lo', "ພາສາລາວ"), // lào
  Lang('hi', "Hindi"), // Ấn
  // Lang('fr', "français"), // pháp
  // Lang('zh', "中国"), // pháp
  // Lang('id', "Indonesian"), // indonesia
  // Lang('pt', "Portuguese"), // bo đầu nha
];