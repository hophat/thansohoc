import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';
import 'name_numbers.dart';

/// Màn tạo hồ sơ mới (tính năng v2): bắt buộc nhập HỌ TÊN để tính được
/// các chỉ số theo tên (Sứ mệnh / Linh hồn / Nhân cách) — thứ app cũ thiếu.
class CreateProfileV2 extends StatefulWidget {
  const CreateProfileV2({Key? key}) : super(key: key);

  @override
  State<CreateProfileV2> createState() => _CreateProfileV2State();
}

class _CreateProfileV2State extends State<CreateProfileV2> {
  final TextEditingController _nameCtrl = TextEditingController();
  DateTime? _birthDate;
  String _relation = 'Bản thân';
  String? _nameError;
  bool _saving = false;

  static const List<String> _relations = [
    'Bản thân',
    'Gia đình',
    'Người yêu',
    'Bạn bè',
    'Khác',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: 'Chọn ngày tháng năm sinh',
      cancelText: 'Huỷ',
      confirmText: 'Chọn',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFEDBE72),
              onPrimary: Color(0xFF5C0E08),
              surface: Color(0xFF6E0D08),
              onSurface: Color(0xFFFFF6DE),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Vui lòng nhập họ tên khai sinh');
      return;
    }
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày tháng năm sinh')),
      );
      return;
    }
    setState(() => _saving = true);
    final saved = await ProfileStore.add(
      TSHProfile(name: name, birthDate: _birthDate!, relation: _relation),
    );
    await ProfileStore.setActiveId(saved.id);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => NameNumbersScreen(profile: saved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Xem trước chỉ số theo tên khi đã gõ tên (gợi ý giá trị của tính năng mới).
    final name = _nameCtrl.text.trim();
    final preview = name.isNotEmpty ? NumerologyEngine.fromName(name) : null;

    return V2Scaffold(
      title: 'Tạo hồ sơ mới',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✦', style: V2Theme.heroNumber(40)),
            const SizedBox(height: 6),
            Text('Khám phá con số của bạn', style: V2Theme.screenTitle()),
            const SizedBox(height: 6),
            Text(
              'Nhập họ tên khai sinh và ngày sinh — app sẽ tính thêm Sứ mệnh, '
              'Linh hồn, Nhân cách từ tên của bạn.',
              style: V2Theme.muted(size: 12.5),
            ),
            const SizedBox(height: 22),
            Text('HỌ VÀ TÊN KHAI SINH', style: V2Theme.label()),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 15.5, color: V2Colors.textMain),
              decoration: InputDecoration(
                hintText: 'Ví dụ: Nguyễn Văn An',
                hintStyle:
                    TextStyle(color: V2Colors.textFaint.withOpacity(0.7)),
                errorText: _nameError,
                filled: true,
                fillColor: Colors.black.withOpacity(0.28),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: V2Colors.gold.withOpacity(0.6), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: V2Colors.gold, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
              ),
              onChanged: (_) => setState(() => _nameError = null),
            ),
            if (preview != null) ...[
              const SizedBox(height: 10),
              Text(
                'Xem trước: Sứ mệnh ${preview.destiny} · Linh hồn '
                '${preview.soulUrge} · Nhân cách ${preview.personality}',
                style: V2Theme.muted(size: 12),
              ),
            ],
            const SizedBox(height: 20),
            Text('NGÀY THÁNG NĂM SINH', style: V2Theme.label()),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: V2Colors.gold.withOpacity(0.6), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _birthDate == null
                            ? 'Chạm để chọn ngày sinh'
                            : formatDateVN(_birthDate!),
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15.5,
                          color: _birthDate == null
                              ? V2Colors.textFaint.withOpacity(0.7)
                              : V2Colors.textMain,
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_month, color: V2Colors.gold, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('QUAN HỆ', style: V2Theme.label()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _relations
                  .map(
                    (r) => V2Chip(
                      label: r,
                      selected: _relation == r,
                      onTap: () => setState(() => _relation = r),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
            GoldButton(
              label: _saving ? 'Đang lưu…' : 'Xem kết quả ✦',
              onPressed: _saving ? null : _submit,
            ),
            const SizedBox(height: 12),
            Text(
              'Thông tin chỉ lưu trên máy của bạn.',
              style: V2Theme.muted(size: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
