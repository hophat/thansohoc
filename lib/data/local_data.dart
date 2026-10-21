import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Tầng dữ liệu local của app (bản offline).
///
/// Toàn bộ nội dung thần số học được đóng gói sẵn trong `assets/data/`
/// và nạp 1 lần vào bộ nhớ khi cần dùng lần đầu:
/// - Số chủ đạo: `sochudao.json` (en) + `sochudao_vi.json` (vi) +
///   `sochudao_hi.json` (hi). Hai file `_vi`/`_hi` không có field `lang`
///   nên được gán lang tương ứng khi nạp.
/// - Đỉnh cao: `dinhcao.json`.
/// - Ngày sinh: `ngaysinh.json`.
///
/// Chuẩn hoá ngôn ngữ: lowercase, lấy 2 ký tự đầu (vd `vi_VN` -> `vi`).
/// Khi không có dữ liệu đúng ngôn ngữ yêu cầu, fallback lần lượt sang
/// `en` rồi `vi` (và ngược lại), cuối cùng mới trả rỗng — giữ đúng hành
/// vi cũ khi Firestore không có document khớp.
class LocalData {
  LocalData._();

  static final LocalData instance = LocalData._();

  bool _loaded = false;
  Future<void>? _loadingFuture;

  List<Map<String, dynamic>> _soChuDao = const [];
  List<Map<String, dynamic>> _dinhCao = const [];
  List<Map<String, dynamic>> _ngaySinh = const [];

  Future<void> _ensureLoaded() {
    if (_loaded) return Future<void>.value();
    return _loadingFuture ??= _load();
  }

  Future<void> _load() async {
    final scdEn = await _readList('assets/data/sochudao.json', lang: 'en');
    final scdVi = await _readList('assets/data/sochudao_vi.json', lang: 'vi');
    final scdHi = await _readList('assets/data/sochudao_hi.json', lang: 'hi');
    _soChuDao = <Map<String, dynamic>>[...scdEn, ...scdVi, ...scdHi];
    _dinhCao = await _readList('assets/data/dinhcao.json');
    _ngaySinh = await _readList('assets/data/ngaysinh.json');
    _loaded = true;
  }

  /// Đọc 1 file JSON dạng List<Map> từ assets. Nếu [lang] khác null,
  /// ghi đè field `lang` cho mọi mục (dùng cho các file sochudao không
  /// chứa sẵn field này).
  Future<List<Map<String, dynamic>>> _readList(String assetPath,
      {String? lang}) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <Map<String, dynamic>>[];
    return decoded.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      if (lang != null) map['lang'] = lang;
      return map;
    }).toList();
  }

  static String _normLang(String lang) {
    final lower = lang.trim().toLowerCase();
    return lower.length > 2 ? lower.substring(0, 2) : lower;
  }

  /// Chuỗi fallback ngôn ngữ: lang yêu cầu -> en -> vi (khử trùng lặp).
  static List<String> _langChain(String lang) {
    final chain = <String>[];
    for (final l in <String>[_normLang(lang), 'en', 'vi']) {
      if (l.isNotEmpty && !chain.contains(l)) chain.add(l);
    }
    return chain;
  }

  /// Tra số chủ đạo theo [scdNumber] và [lang].
  /// Trả về `{}` nếu không có số nào khớp (như khi Firestore rỗng trước đây).
  /// Map trả về là bản sao để caller có thể thêm key (ngay/thang/nam)
  /// mà không làm bẩn cache.
  Future<Map<String, dynamic>> getSoChuDao(
      {required String scdNumber, required String lang}) async {
    await _ensureLoaded();
    for (final l in _langChain(lang)) {
      for (final item in _soChuDao) {
        if (item['scd_number']?.toString() == scdNumber &&
            _normLang(item['lang']?.toString() ?? '') == l) {
          return Map<String, dynamic>.from(item);
        }
      }
    }
    // Fallback cuối: mục đầu tiên có số khớp, bất kể ngôn ngữ.
    for (final item in _soChuDao) {
      if (item['scd_number']?.toString() == scdNumber) {
        return Map<String, dynamic>.from(item);
      }
    }
    return <String, dynamic>{};
  }

  /// Tra đỉnh cao theo [dcNumber] (dinh_cao_key) và [lang].
  /// Trả về `{}` nếu không khớp.
  Future<Map<String, dynamic>> getDinhCao(
      {required String dcNumber, required String lang}) async {
    await _ensureLoaded();
    for (final l in _langChain(lang)) {
      for (final item in _dinhCao) {
        if (item['dinh_cao_key']?.toString() == dcNumber &&
            _normLang(item['lang']?.toString() ?? '') == l) {
          return Map<String, dynamic>.from(item);
        }
      }
    }
    return <String, dynamic>{};
  }

  /// Tra các bài ngày sinh cho [snsKey] (chuỗi ngày tháng năm sinh liền nhau,
  /// vd `15081996`) và [lang].
  ///
  /// Logic tách nhóm chữ số giống nhau (mọi chữ số 1 liên tiếp thành 1 key,
  /// tương tự 2..9, bỏ nhóm rỗng và bỏ số 0) được giữ nguyên từ bản
  /// Firestore cũ; sau đó lọc `ngaysinh.json` theo `sns_key` thuộc các
  /// nhóm đó + `lang`. Nếu theo lang yêu cầu không có kết quả thì thử
  /// fallback `en` -> `vi`.
  Future<List<Map<String, dynamic>>> getNgaySinh(
      {required String snsKey, required String lang}) async {
    await _ensureLoaded();

    final listString = snsKey.split('').map((String text) => text).toList();

    var one = '';
    var two = '';
    var three = '';
    var four = '';
    var five = '';
    var six = '';
    var seven = '';
    var eight = '';
    var nine = '';

    for (var item in listString) {
      if (int.parse(item) == 1) {
        one = one + item;
      } else if (int.parse(item) == 2) {
        two = two + item;
      } else if (int.parse(item) == 3) {
        three = three + item;
      } else if (int.parse(item) == 4) {
        four = four + item;
      } else if (int.parse(item) == 5) {
        five = five + item;
      } else if (int.parse(item) == 6) {
        six = six + item;
      } else if (int.parse(item) == 7) {
        seven = seven + item;
      } else if (int.parse(item) == 8) {
        eight = eight + item;
      } else if (int.parse(item) == 9) {
        nine = nine + item;
      }
    }

    final List<String> queryData = <String>[
      one,
      two,
      three,
      four,
      five,
      six,
      seven,
      eight,
      nine
    ];
    queryData.removeWhere((element) => element.trim().isEmpty);

    for (final l in _langChain(lang)) {
      final result = _ngaySinh
          .where((item) =>
              queryData.contains(item['sns_key']?.toString()) &&
              _normLang(item['lang']?.toString() ?? '') == l)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (result.isNotEmpty) return result;
    }
    return <Map<String, dynamic>>[];
  }
}
