import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';
import 'create_profile_v2.dart';

/// Tương hợp cặp đôi (tính năng v2): chọn 2 hồ sơ, tính % hoà hợp
/// theo Số chủ đạo, Linh hồn và Sứ mệnh bằng NumerologyEngine.compatibility.
class CompatibilityScreen extends StatefulWidget {
  final TSHProfile? initialA;

  const CompatibilityScreen({Key? key, this.initialA}) : super(key: key);

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  List<TSHProfile> _profiles = [];
  TSHProfile? _a;
  TSHProfile? _b;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ProfileStore.load();
    if (!mounted) return;
    TSHProfile? a = widget.initialA;
    if (a != null && !list.any((p) => p.id == a!.id)) a = null;
    a ??= list.isNotEmpty ? list.first : null;
    TSHProfile? b;
    for (final p in list) {
      if (a == null || p.id != a.id) {
        b = p;
        break;
      }
    }
    setState(() {
      _profiles = list;
      _a = a;
      _b = (b != null && (a == null || b.id != a.id)) ? b : null;
      _loading = false;
    });
  }

  Widget _selector({
    required String label,
    required TSHProfile? selected,
    required TSHProfile? other,
    required ValueChanged<TSHProfile> onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: V2Theme.label()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _profiles.map((p) {
            final isSel = selected?.id == p.id;
            final isOther = other?.id == p.id;
            return V2Chip(
              label: p.name,
              selected: isSel,
              onTap: isOther ? null : () => onPick(p),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return V2Scaffold(
      title: 'Tương hợp cặp đôi',
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEDBE72)))
          : _profiles.length < 2
              ? _buildNeedMore()
              : _buildMain(),
    );
  }

  Widget _buildNeedMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('♥', style: V2Theme.heroNumber(44)),
          const SizedBox(height: 12),
          Text('Cần ít nhất 2 hồ sơ', style: V2Theme.cardTitle()),
          const SizedBox(height: 6),
          Text(
            'Tính năng tương hợp so sánh hai người với nhau. Bạn hiện có '
            '${_profiles.length} hồ sơ — hãy tạo thêm hồ sơ cho người ấy nhé.',
            style: V2Theme.muted(size: 12.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: '+ Tạo hồ sơ mới',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProfileV2()),
              );
              _load();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMain() {
    final a = _a;
    final b = _b;
    final result =
        (a != null && b != null) ? NumerologyEngine.compatibility(a, b) : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _selector(
            label: 'NGƯỜI A',
            selected: a,
            other: b,
            onPick: (p) => setState(() => _a = p),
          ),
          const SizedBox(height: 16),
          _selector(
            label: 'NGƯỜI B',
            selected: b,
            other: a,
            onPick: (p) => setState(() => _b = p),
          ),
          if (result != null && a != null && b != null) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberRing(
                  number: NumerologyEngine.lifePath(a.birthDate),
                  label: a.name.split(' ').last,
                  size: 96,
                ),
                Text(
                  '×',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: V2Colors.gold,
                  ),
                ),
                NumberRing(
                  number: NumerologyEngine.lifePath(b.birthDate),
                  label: b.name.split(' ').last,
                  size: 96,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(child: Text('${result.overall}%', style: V2Theme.heroNumber(46))),
            const SizedBox(height: 4),
            Center(
              child: Text(
                result.title,
                style: V2Theme.cardTitle(),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                'Mức độ hoà hợp tổng thể',
                style: V2Theme.muted(size: 11.5),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: V2Theme.glassCard(),
              child: Column(
                children: [
                  MeterBar(label: 'Số chủ đạo', value: result.lifePathScore),
                  MeterBar(label: 'Linh hồn', value: result.soulScore),
                  MeterBar(label: 'Sứ mệnh', value: result.destinyScore),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Text(
              'Hãy chọn đủ 2 người khác nhau để xem mức độ tương hợp.',
              style: V2Theme.muted(size: 12.5),
            ),
          ],
        ],
      ),
    );
  }
}
