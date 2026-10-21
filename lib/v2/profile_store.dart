import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Hồ sơ thần số học của một người (bản thân / người thân).
class TSHProfile {
  String id;
  String name;
  DateTime birthDate;
  String relation;

  TSHProfile({
    this.id = '',
    required this.name,
    required this.birthDate,
    this.relation = '',
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'relation': relation,
      };

  factory TSHProfile.fromJson(Map<String, dynamic> json) => TSHProfile(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        birthDate:
            DateTime.tryParse((json['birthDate'] ?? '') as String) ??
                DateTime(2000, 1, 1),
        relation: (json['relation'] ?? '') as String,
      );
}

/// Lưu trữ danh sách hồ sơ bằng SharedPreferences.
///
/// Dữ liệu nằm ở key 'v2_profiles' (chuỗi JSON của List<TSHProfile>),
/// hồ sơ đang chọn nằm ở key 'v2_active_profile_id'.
class ProfileStore {
  static const String _profilesKey = 'v2_profiles';
  static const String _activeIdKey = 'v2_active_profile_id';

  static Future<List<TSHProfile>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profilesKey);
    if (raw == null || raw.isEmpty) return <TSHProfile>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <TSHProfile>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(TSHProfile.fromJson)
          .toList();
    } catch (_) {
      // JSON hỏng -> coi như chưa có hồ sơ thay vì crash app.
      return <TSHProfile>[];
    }
  }

  static Future<void> saveAll(List<TSHProfile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_profilesKey, raw);
  }

  /// Thêm một hồ sơ mới. Nếu [p] chưa có id thì tự sinh id bằng
  /// millisecondsSinceEpoch. Trả về chính hồ sơ đã có id.
  static Future<TSHProfile> add(TSHProfile p) async {
    if (p.id.isEmpty) {
      p.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    final profiles = await load();
    profiles.add(p);
    await saveAll(profiles);
    return p;
  }

  static Future<void> remove(String id) async {
    final profiles = await load();
    profiles.removeWhere((p) => p.id == id);
    await saveAll(profiles);
    // Nếu hồ sơ đang active bị xoá thì bỏ luôn activeId cho nhất quán.
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_activeIdKey) == id) {
      await prefs.remove(_activeIdKey);
    }
  }

  static Future<String?> activeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeIdKey);
  }

  static Future<void> setActiveId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeIdKey, id);
  }

  /// Hồ sơ đang được chọn; nếu chưa chọn thì trả phần tử đầu tiên.
  /// Trả null khi danh sách rỗng.
  static Future<TSHProfile?> active() async {
    final profiles = await load();
    if (profiles.isEmpty) return null;
    final id = await activeId();
    if (id != null) {
      for (final p in profiles) {
        if (p.id == id) return p;
      }
    }
    return profiles.first;
  }
}
