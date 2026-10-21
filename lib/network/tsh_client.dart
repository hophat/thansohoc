import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/data/local_data.dart';

/// Lớp tương thích ngược với client cũ.
///
/// Trước đây các hàm này đọc dữ liệu từ Firestore (và bản nháp API
/// gulagi.com qua Dio); nay toàn bộ nội dung đã được đóng gói trong
/// `assets/data/` và delegate sang [LocalData] để app hoạt động 100%
/// offline. Chữ ký hàm và kiểu trả về (`Future<Res?>`, `Res(true, "22",
/// data)`) được giữ nguyên nên các caller (home, detail) không đổi.
class TSHClient {
  TSHClient._();

  static TSHClient? _instance;

  static TSHClient get instance {
    _instance ??= TSHClient._();
    return _instance!;
  }

  Future<Res?> getSoChuDao({String scdNumber = '2', String lang = 'en'}) async {
    final Map<String, dynamic> data = await LocalData.instance
        .getSoChuDao(scdNumber: scdNumber, lang: lang);
    return Res(true, "22", data);
  }

  Future<Res?> getDinhCao({String dcNumber = '2', String lang = 'en'}) async {
    final Map<String, dynamic> data =
        await LocalData.instance.getDinhCao(dcNumber: dcNumber, lang: lang);
    return Res(true, "22", data);
  }

  Future<Res?> getNgaySinh({String snsKey = '22223344', String lang = 'en'}) async {
    final List<Map<String, dynamic>> data =
        await LocalData.instance.getNgaySinh(snsKey: snsKey, lang: lang);
    return Res(true, "22", data);
  }
}
