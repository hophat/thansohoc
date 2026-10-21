import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_than_so_hoc_2/v2/meanings.dart';
import 'package:flutter_app_than_so_hoc_2/v2/numerology_engine.dart';
import 'package:flutter_app_than_so_hoc_2/v2/profile_store.dart';

void main() {
  group('reduce', () {
    test('reduceWithMaster rút gọn thường và giữ master', () {
      // 39 -> 3+9=12 -> 1+2=3
      expect(NumerologyEngine.reduceWithMaster(39), 3);
      // 29 -> 2+9=11 là số master, dừng ngay
      expect(NumerologyEngine.reduceWithMaster(29), 11);
      // 38 -> 3+8=11 master
      expect(NumerologyEngine.reduceWithMaster(38), 11);
      expect(NumerologyEngine.reduceWithMaster(22), 22);
      expect(NumerologyEngine.reduceWithMaster(33), 33);
      // 48 -> 12 -> 3
      expect(NumerologyEngine.reduceWithMaster(48), 3);
    });

    test('reduceSingle luôn về 1 chữ số kể cả từ master', () {
      expect(NumerologyEngine.reduceSingle(22), 4);
      expect(NumerologyEngine.reduceSingle(33), 6);
      expect(NumerologyEngine.reduceSingle(29), 2); // 29 -> 11 -> 2
      expect(NumerologyEngine.reduceSingle(9), 9);
    });
  });

  group('lifePath', () {
    test('15/08/1996 -> 3', () {
      // Cộng mọi chữ số của 15/08/1996:
      // 1+5+0+8+1+9+9+6 = 39 -> 3+9 = 12 -> 1+2 = 3.
      // (Số 8 trong design minh hoạ KHÔNG phải kết quả của ngày này.)
      expect(NumerologyEngine.lifePath(DateTime(1996, 8, 15)), 3);
    });

    test('trường hợp master 11: 06/05/1980 -> 11', () {
      // 0+6+0+5+1+9+8+0 = 29 -> 2+9 = 11, là số master nên giữ nguyên.
      expect(NumerologyEngine.lifePath(DateTime(1980, 5, 6)), 11);
    });

    test('trường hợp master 22: 20/01/1990 -> 22', () {
      // 2+0+0+1+1+9+9+0 = 22, là số master nên giữ nguyên.
      expect(NumerologyEngine.lifePath(DateTime(1990, 1, 20)), 22);
    });
  });

  group('birthDay / attitude / maturity', () {
    test('birthDay giữ master', () {
      expect(NumerologyEngine.birthDay(DateTime(2000, 1, 22)), 22);
      // 29 -> 2+9 = 11 master
      expect(NumerologyEngine.birthDay(DateTime(2000, 1, 29)), 11);
      // 15 -> 1+5 = 6
      expect(NumerologyEngine.birthDay(DateTime(2000, 1, 15)), 6);
    });

    test('attitude = ngày + tháng', () {
      // 15 + 8 = 23 -> 2+3 = 5
      expect(NumerologyEngine.attitude(DateTime(1996, 8, 15)), 5);
    });

    test('maturity = lifePath + destiny, giữ master', () {
      expect(NumerologyEngine.maturity(3, 3), 6);
      // 11 + 22 = 33 master
      expect(NumerologyEngine.maturity(11, 22), 33);
    });
  });

  group('normalizeName', () {
    test('bỏ dấu tiếng Việt và viết hoa', () {
      expect(NumerologyEngine.normalizeName('Nguyễn Văn Ăn'), 'NGUYEN VAN AN');
    });

    test('chữ Đ -> D', () {
      final r = NumerologyEngine.normalizeName('Đặng Thị Hồng Đào');
      expect(r, 'DANG THI HONG DAO');
      expect(r.contains('DANG'), isTrue);
    });

    test('gộp khoảng trắng và bỏ ký tự lạ', () {
      expect(
        NumerologyEngine.normalizeName('  Trần   Văn-Bình! '),
        'TRAN VAN BINH',
      );
    });
  });

  group('fromName', () {
    test('Nguyễn Văn An -> destiny 3, soul 1, personality 11', () {
      // Sau chuẩn hoá: NGUYEN VAN AN. Giá trị Pythagoras (A=1..I=9 lặp):
      // N=5 G=7 U=3 Y=7 E=5 N=5 | V=4 A=1 N=5 | A=1 N=5
      // Tổng tất cả = 32 + 10 + 6 = 48 -> 12 -> 3  => destiny = 3
      // Nguyên âm (A E I O U): U=3, E=5, A=1, A=1 => 10 -> 1 => soul = 1
      // Phụ âm = 48 - 10 = 38 -> 3+8 = 11 master => personality = 11
      final n = NumerologyEngine.fromName('Nguyễn Văn An');
      expect(n.destiny, 3);
      expect(n.soulUrge, 1);
      expect(n.personality, 11);
    });
  });

  group('personal cycles', () {
    test('personalYear/Month/Day tại 20/10/2026 cho 15/08/1996', () {
      final dob = DateTime(1996, 8, 15);
      final at = DateTime(2026, 10, 20);
      // Năm cá nhân: ngày 15->6, tháng 8, năm 2026->2+0+2+6=10->1
      // 6 + 8 + 1 = 15 -> 6
      expect(NumerologyEngine.personalYear(dob, at), 6);
      // Tháng cá nhân: 6 + tháng 10 = 16 -> 7
      expect(NumerologyEngine.personalMonth(dob, at), 7);
      // Ngày cá nhân: 7 + ngày 20 = 27 -> 9
      expect(NumerologyEngine.personalDay(dob, at), 9);
    });
  });

  group('birthChartCounts', () {
    test('đếm chữ số của 15/08/1996', () {
      // Chuỗi "15081996" (bỏ số 0): 1 xuất hiện 2 lần, 9 xuất hiện 2 lần,
      // 5/6/8 mỗi số 1 lần, 2/3/4/7 không có.
      final c = NumerologyEngine.birthChartCounts(DateTime(1996, 8, 15));
      expect(c[1], 2);
      expect(c[9], 2);
      expect(c[5], 1);
      expect(c[6], 1);
      expect(c[8], 1);
      expect(c[2], 0);
      expect(c[3], 0);
      expect(c[4], 0);
      expect(c[7], 0);
    });
  });

  group('peaks & peakAges', () {
    test('đỉnh cao của 15/08/1996 = [5, 4, 9, 6]', () {
      // Thành phần rút về 1 chữ số: tháng 8, ngày 15->6, năm 1996->(1+9+9+6)=25->7
      // p1 = 8 + 6 = 14 -> 5
      // p2 = 6 + 7 = 13 -> 4
      // p3 = p1 + p2 = 5 + 4 = 9
      // p4 = 8 + 7 = 15 -> 6
      expect(NumerologyEngine.peaks(DateTime(1996, 8, 15)), [5, 4, 9, 6]);
    });

    test('tuổi đỉnh cao của 15/08/1996 = [33, 42, 51, 60]', () {
      // Số chủ đạo = 3 => đỉnh 1 ở tuổi 36 - 3 = 33, các đỉnh sau +9.
      expect(
        NumerologyEngine.peakAges(DateTime(1996, 8, 15)),
        [33, 42, 51, 60],
      );
    });
  });

  group('compatibility', () {
    final a = TSHProfile(
      id: 'a',
      name: 'Nguyễn Văn An',
      birthDate: DateTime(1996, 8, 15),
      relation: 'Bản thân',
    );
    final b = TSHProfile(
      id: 'b',
      name: 'Trần Thị Bình',
      birthDate: DateTime(1970, 3, 2),
      relation: 'Mẹ',
    );

    test('deterministic: cùng input cho cùng output', () {
      final r1 = NumerologyEngine.compatibility(a, b);
      final r2 = NumerologyEngine.compatibility(a, b);
      expect(r1.overall, r2.overall);
      expect(r1.lifePathScore, r2.lifePathScore);
      expect(r1.soulScore, r2.soulScore);
      expect(r1.destinyScore, r2.destinyScore);
      expect(r1.title, r2.title);
    });

    test('overall luôn nằm trong 45..98', () {
      final r = NumerologyEngine.compatibility(a, b);
      expect(r.overall, greaterThanOrEqualTo(45));
      expect(r.overall, lessThanOrEqualTo(98));
    });

    test('so với chính mình -> mọi cặp số bằng nhau, overall 92', () {
      // lifePath 3=3, soul 1=1, destiny 3=3 -> mỗi cặp 92 điểm (không có
      // số master nên không cộng bonus) -> overall = 92.
      final r = NumerologyEngine.compatibility(a, a);
      expect(r.lifePathScore, 92);
      expect(r.soulScore, 92);
      expect(r.destinyScore, 92);
      expect(r.overall, 92);
      expect(r.title, 'Cặp đôi tâm đầu ý hợp');
    });
  });

  group('Meanings', () {
    test('titleOf tách tiêu đề trước dấu |', () {
      expect(
        Meanings.titleOf(Meanings.lifePathTitle, 1),
        'Người tiên phong',
      );
      expect(
        Meanings.titleOf(Meanings.personalDayInfo, 7),
        'Ngày chiêm nghiệm',
      );
      expect(Meanings.titleOf(Meanings.lifePathTitle, 99), '');
    });

    test('đủ nội dung cho các số chính', () {
      for (var i = 1; i <= 9; i++) {
        expect(Meanings.lifePathTitle[i], isNotNull);
        expect(Meanings.destinyShort[i], isNotNull);
        expect(Meanings.soulShort[i], isNotNull);
        expect(Meanings.personalityShort[i], isNotNull);
        expect(Meanings.personalDayInfo[i], isNotNull);
        expect(Meanings.personalYearShort[i], isNotNull);
        expect(Meanings.personalMonthShort[i], isNotNull);
      }
      for (final m in [11, 22, 33]) {
        expect(Meanings.lifePathTitle[m], isNotNull);
      }
      for (final m in [11, 22]) {
        expect(Meanings.destinyShort[m], isNotNull);
        expect(Meanings.soulShort[m], isNotNull);
        expect(Meanings.personalityShort[m], isNotNull);
      }
    });
  });
}
