import 'profile_store.dart';

/// Bộ chỉ số tính từ họ tên: Sứ mệnh (destiny), Linh hồn (soul urge),
/// Nhân cách (personality).
class NameNumbers {
  final int destiny;
  final int soulUrge;
  final int personality;
  const NameNumbers(this.destiny, this.soulUrge, this.personality);
}

/// Kết quả tương hợp giữa hai hồ sơ.
class CompatibilityResult {
  final int overall;
  final int lifePathScore;
  final int soulScore;
  final int destinyScore;
  final String title;
  const CompatibilityResult({
    required this.overall,
    required this.lifePathScore,
    required this.soulScore,
    required this.destinyScore,
    required this.title,
  });
}

/// Engine tính toán thần số học (trường phái Pythagoras).
///
/// Quy ước chung:
/// - Các "số lõi" (Chủ đạo, Ngày sinh, Thái độ, Sứ mệnh, Linh hồn,
///   Nhân cách, Trưởng thành, Đỉnh cao) GIỮ số master 11/22/33.
/// - Các số cá nhân theo chu kỳ (Năm/Tháng/Ngày cá nhân) luôn rút gọn
///   về 1 chữ số 1-9.
/// - Mọi hàm đều thuần (pure), không phụ thuộc trạng thái ngoài.
class NumerologyEngine {
  static const Set<int> _masterNumbers = {11, 22, 33};

  static int _digitSum(int value) {
    var v = value.abs();
    var sum = 0;
    while (v > 0) {
      sum += v % 10;
      v ~/= 10;
    }
    return sum;
  }

  /// Cộng các chữ số lập lại cho đến khi <= 9 hoặc gặp số master
  /// 11/22/33 thì dừng và giữ nguyên.
  static int reduceWithMaster(int value) {
    var v = value.abs();
    while (v > 9 && !_masterNumbers.contains(v)) {
      v = _digitSum(v);
    }
    return v;
  }

  /// Cộng các chữ số lập lại cho đến khi còn đúng 1 chữ số 1-9
  /// (số master cũng bị rút tiếp, vd 22 -> 4, 33 -> 6).
  static int reduceSingle(int value) {
    var v = value.abs();
    if (v == 0) return 0;
    while (v > 9) {
      v = _digitSum(v);
    }
    return v;
  }

  static String _twoDigits(int v) => v.toString().padLeft(2, '0');

  /// Số Chủ Đạo: cộng TẤT CẢ chữ số của ngày + tháng + năm sinh
  /// (định dạng ddMMyyyy) rồi rút gọn giữ master.
  /// Vd 15/08/1996: 1+5+0+8+1+9+9+6 = 39 -> 12 -> 3.
  static int lifePath(DateTime dob) {
    final s = '${_twoDigits(dob.day)}${_twoDigits(dob.month)}${dob.year}';
    var total = 0;
    for (final ch in s.split('')) {
      total += int.parse(ch);
    }
    return reduceWithMaster(total);
  }

  /// Số Ngày Sinh: rút gọn (giữ master) của chính ngày sinh.
  /// Vd sinh ngày 22 -> 22, ngày 29 -> 2+9 = 11, ngày 15 -> 6.
  static int birthDay(DateTime dob) => reduceWithMaster(dob.day);

  /// Số Thái Độ: (ngày + tháng) rút gọn giữ master.
  static int attitude(DateTime dob) => reduceWithMaster(dob.day + dob.month);

  /// Số Trưởng Thành: (Số Chủ Đạo + Số Sứ Mệnh) rút gọn giữ master.
  static int maturity(int lifePathValue, int destinyValue) =>
      reduceWithMaster(lifePathValue + destinyValue);

  // ---------------------------------------------------------------------------
  // Họ tên
  // ---------------------------------------------------------------------------

  /// Bảng bỏ dấu tiếng Việt: ánh xạ mọi biến thể có dấu về chữ gốc.
  static const Map<String, String> _vnBase = {
    'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
    'ă': 'a', 'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
    'â': 'a', 'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
    'đ': 'd',
    'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
    'ê': 'e', 'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
    'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
    'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
    'ô': 'o', 'ố': 'o', 'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
    'ơ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
    'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
    'ư': 'u', 'ứ': 'u', 'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
    'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
  };

  /// Chuẩn hoá họ tên: bỏ dấu tiếng Việt, viết hoa, chỉ giữ A-Z và
  /// khoảng trắng (gộp nhiều khoảng trắng thành một, cắt hai đầu).
  /// Vd "Nguyễn Văn Ăn" -> "NGUYEN VAN AN", "Đặng" -> "DANG".
  static String normalizeName(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final lower = ch.toLowerCase();
      final base = _vnBase[lower] ?? lower;
      if (base.length == 1) {
        final code = base.codeUnitAt(0);
        if (code >= 97 && code <= 122) {
          buffer.write(base.toUpperCase());
          continue;
        }
      }
      if (ch == ' ' || ch == '\t' || ch == '-') {
        // Khoảng trắng và dấu gạch ngang được coi là dấu tách từ.
        buffer.write(' ');
      }
      // Các ký tự còn lại (số, dấu câu...) bị loại bỏ.
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Giá trị Pythagoras của một chữ cái A-Z: A=1, B=2, ..., I=9, J=1, ...
  static int _letterValue(String letter) =>
      (letter.codeUnitAt(0) - 65) % 9 + 1;

  static const Set<String> _vowels = {'A', 'E', 'I', 'O', 'U'};

  /// Tính bộ chỉ số từ họ tên đầy đủ (tên đã chuẩn hoá qua
  /// [normalizeName] ngay trong hàm, truyền tên có dấu cũng được).
  /// - destiny: tổng giá trị MỌI chữ cái.
  /// - soulUrge: tổng giá trị các nguyên âm A E I O U (chữ Y tính là
  ///   phụ âm theo quy ước phổ biến của trường phái Pythagoras).
  /// - personality: tổng giá trị các phụ âm.
  /// Cả ba đều rút gọn giữ master.
  static NameNumbers fromName(String fullName) {
    final normalized = normalizeName(fullName);
    var totalAll = 0;
    var totalVowels = 0;
    for (final ch in normalized.split('')) {
      if (ch == ' ') continue;
      final v = _letterValue(ch);
      totalAll += v;
      if (_vowels.contains(ch)) totalVowels += v;
    }
    final totalConsonants = totalAll - totalVowels;
    return NameNumbers(
      reduceWithMaster(totalAll),
      reduceWithMaster(totalVowels),
      reduceWithMaster(totalConsonants),
    );
  }

  // ---------------------------------------------------------------------------
  // Chu kỳ cá nhân (luôn rút về 1 chữ số)
  // ---------------------------------------------------------------------------

  /// Năm Cá Nhân: rút gọn 1 chữ số của (ngày sinh + tháng sinh + năm xét).
  /// Các thành phần được rút gọn trước khi cộng — kết quả tương đương
  /// cộng tổng mọi chữ số rồi rút gọn (tính chất modulo 9).
  /// [at] mặc định là hôm nay.
  static int personalYear(DateTime dob, [DateTime? at]) {
    final when = at ?? DateTime.now();
    return reduceSingle(
      reduceSingle(dob.day) + reduceSingle(dob.month) + reduceSingle(when.year),
    );
  }

  /// Tháng Cá Nhân: (Năm Cá Nhân + tháng xét) rút về 1 chữ số.
  static int personalMonth(DateTime dob, [DateTime? at]) {
    final when = at ?? DateTime.now();
    return reduceSingle(personalYear(dob, when) + when.month);
  }

  /// Ngày Cá Nhân: (Tháng Cá Nhân + ngày xét) rút về 1 chữ số.
  static int personalDay(DateTime dob, [DateTime? at]) {
    final when = at ?? DateTime.now();
    return reduceSingle(personalMonth(dob, when) + when.day);
  }

  // ---------------------------------------------------------------------------
  // Biểu đồ ngày sinh & đỉnh cao
  // ---------------------------------------------------------------------------

  /// Đếm số lần xuất hiện của từng chữ số 1-9 trong chuỗi ddMMyyyy
  /// (bỏ qua số 0). Map trả về luôn đủ key 1..9, chữ số nào không có
  /// trong ngày sinh thì count = 0 (UI vẽ ô trống cho các số này).
  static Map<int, int> birthChartCounts(DateTime dob) {
    final counts = <int, int>{for (var i = 1; i <= 9; i++) i: 0};
    final s = '${_twoDigits(dob.day)}${_twoDigits(dob.month)}${dob.year}';
    for (final ch in s.split('')) {
      final d = int.parse(ch);
      if (d != 0) counts[d] = counts[d]! + 1;
    }
    return counts;
  }

  /// 4 Đỉnh Cao đời người. Tháng/ngày/năm được rút về 1 chữ số trước
  /// khi cộng (năm rút từ tổng các chữ số của năm), tổng nào cũng rút
  /// gọn giữ master:
  /// p1 = tháng + ngày, p2 = ngày + năm, p3 = p1 + p2 (dùng giá trị
  /// đỉnh 1 & 2 đã rút), p4 = tháng + năm.
  static List<int> peaks(DateTime dob) {
    final m = reduceSingle(dob.month);
    final d = reduceSingle(dob.day);
    final y = reduceSingle(_digitSum(dob.year));
    final p1 = reduceWithMaster(m + d);
    final p2 = reduceWithMaster(d + y);
    final p3 = reduceWithMaster(p1 + p2);
    final p4 = reduceWithMaster(m + y);
    return [p1, p2, p3, p4];
  }

  /// Tuổi đạt từng đỉnh cao: đỉnh 1 ở tuổi 36 - Số Chủ Đạo (đã rút về
  /// 1 chữ số), mỗi đỉnh sau cách đỉnh trước 9 năm.
  static List<int> peakAges(DateTime dob) {
    final first = 36 - reduceSingle(lifePath(dob));
    return [first, first + 9, first + 18, first + 27];
  }

  // ---------------------------------------------------------------------------
  // Tương hợp cặp đôi
  // ---------------------------------------------------------------------------

  /// Nhóm hài hoà của một con số: master quy về số gốc trước
  /// (11 -> 2, 22 -> 4, 33 -> 6) nhờ [reduceSingle].
  /// Nhóm A = {1,5,7}, B = {2,4,8}, C = {3,6,9}.
  static String _groupOf(int n) {
    final root = reduceSingle(n);
    if (root == 1 || root == 5 || root == 7) return 'A';
    if (root == 2 || root == 4 || root == 8) return 'B';
    return 'C';
  }

  /// Điểm hài hoà của một cặp số:
  /// hai số bằng nhau = 92; cùng nhóm = 88; A-C = 82; B-C = 78;
  /// A-B = 70. Cộng thêm 4 điểm nếu một trong hai số là số master.
  static int _pairScore(int x, int y) {
    int score;
    if (x == y) {
      score = 92;
    } else {
      final gx = _groupOf(x);
      final gy = _groupOf(y);
      if (gx == gy) {
        score = 88;
      } else if ({gx, gy}.containsAll({'A', 'C'})) {
        score = 82;
      } else if ({gx, gy}.containsAll({'B', 'C'})) {
        score = 78;
      } else {
        score = 70; // A-B
      }
    }
    if (_masterNumbers.contains(x) || _masterNumbers.contains(y)) {
      score += 4;
    }
    return score;
  }

  /// Đánh giá tương hợp hai hồ sơ.
  ///
  /// LƯU Ý: đây là heuristic tham khảo phục vụ trải nghiệm giải trí
  /// trong app, KHÔNG phải phương pháp chuẩn hoá duy nhất của thần số
  /// học. overall = 50% điểm Số Chủ Đạo + 30% điểm Linh Hồn + 20%
  /// điểm Sứ Mệnh, làm tròn, giới hạn trong 45..98.
  static CompatibilityResult compatibility(TSHProfile a, TSHProfile b) {
    final lpScore = _pairScore(lifePath(a.birthDate), lifePath(b.birthDate));
    final nameA = fromName(a.name);
    final nameB = fromName(b.name);
    final soulScore = _pairScore(nameA.soulUrge, nameB.soulUrge);
    final destinyScore = _pairScore(nameA.destiny, nameB.destiny);
    var overall =
        (lpScore * 0.5 + soulScore * 0.3 + destinyScore * 0.2).round();
    if (overall < 45) overall = 45;
    if (overall > 98) overall = 98;
    final String title;
    if (overall >= 85) {
      title = 'Cặp đôi tâm đầu ý hợp';
    } else if (overall >= 75) {
      title = 'Cặp đôi bù trừ hoà hợp';
    } else if (overall >= 65) {
      title = 'Cặp đôi cần thấu hiểu';
    } else {
      title = 'Cặp đôi nhiều thử thách';
    }
    return CompatibilityResult(
      overall: overall,
      lifePathScore: lpScore,
      soulScore: soulScore,
      destinyScore: destinyScore,
      title: title,
    );
  }
}
