import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';
import 'create_profile_v2.dart';
import 'name_numbers.dart';

/// Danh sách hồ sơ đã lưu (tính năng v2): thay giới hạn "1 ngày sinh duy nhất"
/// của app cũ bằng nhiều hồ sơ có quan hệ.
class ProfilesV2 extends StatefulWidget {
  const ProfilesV2({Key? key}) : super(key: key);

  @override
  State<ProfilesV2> createState() => _ProfilesV2State();
}

class _ProfilesV2State extends State<ProfilesV2> {
  List<TSHProfile> _profiles = [];
  String? _activeId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final list = await ProfileStore.load();
    final activeId = await ProfileStore.activeId();
    if (!mounted) return;
    setState(() {
      _profiles = list;
      _activeId = activeId ??
          (list.isNotEmpty ? list.first.id : null);
      _loading = false;
    });
  }

  Future<void> _openProfile(TSHProfile p) async {
    await ProfileStore.setActiveId(p.id);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NameNumbersScreen(profile: p)),
    );
    _reload();
  }

  Future<void> _confirmDelete(TSHProfile p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF6E0D08),
        title: Text('Xoá hồ sơ?',
            style: GoogleFonts.beVietnamPro(
                color: V2Colors.goldLight, fontWeight: FontWeight.w700)),
        content: Text(
          'Hồ sơ của "${p.name}" sẽ bị xoá khỏi máy. Bạn không thể hoàn tác.',
          style: GoogleFonts.beVietnamPro(color: V2Colors.textMain),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Huỷ', style: TextStyle(color: V2Colors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ProfileStore.remove(p.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return V2Scaffold(
      title: 'Hồ sơ của tôi',
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: V2Colors.goldLight),
          tooltip: 'Thêm hồ sơ',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateProfileV2()),
            );
            _reload();
          },
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEDBE72)))
          : _profiles.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('☰', style: V2Theme.heroNumber(44)),
          const SizedBox(height: 12),
          Text('Chưa có hồ sơ nào', style: V2Theme.cardTitle()),
          const SizedBox(height: 6),
          Text(
            'Tạo hồ sơ đầu tiên cho bạn hoặc người thân để xem bộ chỉ số '
            'thần số học đầy đủ, gồm cả chỉ số theo họ tên.',
            style: V2Theme.muted(size: 12.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: '+ Tạo hồ sơ',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProfileV2()),
              );
              _reload();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      itemCount: _profiles.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, i) {
        if (i == _profiles.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GhostButton(
              label: '+ Thêm hồ sơ',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateProfileV2()),
                );
                _reload();
              },
            ),
          );
        }
        final p = _profiles[i];
        final lifePath = NumerologyEngine.lifePath(p.birthDate);
        final destiny = NumerologyEngine.fromName(p.name).destiny;
        final isActive = p.id == _activeId;
        return InkWell(
          onTap: () => _openProfile(p),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: V2Colors.gold.withOpacity(0.25), width: 1),
              ),
            ),
            child: Row(
              children: [
                NumberRing(number: lifePath, size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              p.name,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: V2Colors.textMain,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: V2Colors.gold,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'CHÍNH',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: V2Colors.darkOnGold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${p.relation.isEmpty ? 'Hồ sơ' : p.relation} · '
                        '${formatDateVN(p.birthDate)} · Sứ mệnh $destiny',
                        style: V2Theme.muted(size: 11.5),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: V2Colors.gold),
                  color: const Color(0xFF6E0D08),
                  onSelected: (v) async {
                    if (v == 'view') _openProfile(p);
                    if (v == 'active') {
                      await ProfileStore.setActiveId(p.id);
                      _reload();
                    }
                    if (v == 'delete') _confirmDelete(p);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Text('Xem chỉ số',
                          style: TextStyle(color: V2Colors.textMain)),
                    ),
                    PopupMenuItem(
                      value: 'active',
                      child: Text('Đặt làm chính',
                          style: TextStyle(color: V2Colors.textMain)),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Xoá hồ sơ',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
