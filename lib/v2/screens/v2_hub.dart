import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../meanings.dart';
import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';
import 'compatibility.dart';
import 'create_profile_v2.dart';
import 'name_numbers.dart';
import 'premium.dart';
import 'profiles_v2.dart';
import 'share_story.dart';

/// Màn "✦ Tính năng mới" — cổng vào các tính năng v2, đẩy từ nút
/// "✦ Tính năng mới" ở màn hình chính cũ. Design mới chỉ áp dụng ở đây
/// và các màn v2; các màn cũ giữ nguyên.
class V2Hub extends StatefulWidget {
  const V2Hub({Key? key}) : super(key: key);

  @override
  State<V2Hub> createState() => _V2HubState();
}

class _V2HubState extends State<V2Hub> {
  TSHProfile? _active;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final active = await ProfileStore.active();
    if (!mounted) return;
    setState(() {
      _active = active;
      _loading = false;
    });
  }

  Future<void> _push(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    _reload();
  }

  void _needProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Hãy tạo hồ sơ đầu tiên để dùng tính năng này nhé')),
    );
    _push(const CreateProfileV2());
  }

  @override
  Widget build(BuildContext context) {
    return V2Scaffold(
      title: '✦ Tính năng mới',
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFEDBE72)))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _active == null ? _buildNoProfileCard() : _buildTodayCard(),
                  const SizedBox(height: 20),
                  Text('KHÁM PHÁ', style: V2Theme.label()),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.25,
                    children: [
                      _HubTile(
                        icon: Icons.abc,
                        title: 'Chỉ số theo tên',
                        desc: 'Sứ mệnh · Linh hồn · Nhân cách',
                        onTap: () => _active == null
                            ? _needProfile()
                            : _push(NameNumbersScreen(profile: _active!)),
                      ),
                      _HubTile(
                        icon: Icons.people_alt,
                        title: 'Hồ sơ của tôi',
                        desc: 'Bạn, gia đình & người thân',
                        onTap: () => _push(const ProfilesV2()),
                      ),
                      _HubTile(
                        icon: Icons.favorite,
                        title: 'Tương hợp cặp đôi',
                        desc: 'Hai bạn hợp nhau bao nhiêu %?',
                        onTap: () => _push(const CompatibilityScreen()),
                      ),
                      _HubTile(
                        icon: Icons.share,
                        title: 'Chia sẻ story',
                        desc: 'Ảnh dọc 9:16 có watermark',
                        onTap: () => _active == null
                            ? _needProfile()
                            : _push(ShareStoryScreen(profile: _active!)),
                      ),
                      _HubTile(
                        icon: Icons.workspace_premium,
                        title: 'Premium',
                        desc: 'Mở khoá diễn giải sâu',
                        gold: true,
                        onTap: () => _push(const PremiumScreen()),
                      ),
                      _HubTile(
                        icon: Icons.add_circle_outline,
                        title: 'Tạo hồ sơ mới',
                        desc: 'Thêm người thân, bạn bè',
                        onTap: () => _push(const CreateProfileV2()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNoProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: V2Theme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Năng lượng hôm nay', style: V2Theme.cardTitle()),
          const SizedBox(height: 6),
          Text(
            'Tạo hồ sơ đầu tiên (họ tên + ngày sinh) để xem Ngày / Tháng / '
            'Năm cá nhân và bộ chỉ số theo tên của bạn.',
            style: V2Theme.muted(size: 12.5),
          ),
          const SizedBox(height: 14),
          GoldButton(
            label: 'Tạo hồ sơ của tôi',
            onPressed: () => _push(const CreateProfileV2()),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard() {
    final p = _active!;
    final now = DateTime.now();
    final pDay = NumerologyEngine.personalDay(p.birthDate, now);
    final pMonth = NumerologyEngine.personalMonth(p.birthDate, now);
    final pYear = NumerologyEngine.personalYear(p.birthDate, now);
    final dayRaw = Meanings.personalDayInfo[pDay];
    final dayTitle = meaningTitle(dayRaw);
    final dayDesc = meaningDesc(dayRaw);
    final yearRaw = Meanings.personalYearShort[pYear];

    return InkWell(
      onTap: () => _push(NameNumbersScreen(profile: p)),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: V2Theme.solidGoldCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'NĂNG LƯỢNG HÔM NAY · ${p.name}',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: const Color(0xFF7A3B12),
                    ),
                  ),
                ),
                Text(
                  formatDateVN(now),
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 11, color: const Color(0xFF7A3B12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pDay',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 54,
                    fontWeight: FontWeight.w800,
                    height: 1,
                    color: const Color(0xFF9B150E),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayTitle.isEmpty
                            ? 'Ngày cá nhân $pDay'
                            : 'Ngày cá nhân $pDay — $dayTitle',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4A0805),
                        ),
                      ),
                      if (dayDesc.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          dayDesc,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11.5,
                            height: 1.5,
                            color: const Color(0xFF7A3B12),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _miniStat('Tháng cá nhân', pMonth,
                    meaningTitle(Meanings.personalMonthShort[pMonth])),
                const SizedBox(width: 10),
                _miniStat('Năm cá nhân', pYear, meaningTitle(yearRaw)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Chạm để xem toàn bộ chỉ số của ${p.name} →',
              style: GoogleFonts.beVietnamPro(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9B150E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, int number, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              '$number',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF9B150E),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A3B12),
                    ),
                  ),
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A0805),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final bool gold;

  const _HubTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
    this.gold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: gold
              ? V2Theme.solidGoldCard(radius: 16)
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: V2Colors.goldLight.withOpacity(0.09),
                  border: Border.all(color: V2Colors.gold.withOpacity(0.4)),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 22,
                  color: gold ? const Color(0xFF9B150E) : V2Colors.gold),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: gold ? V2Colors.darkOnGold : V2Colors.textMain,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10.5,
                  height: 1.4,
                  color: gold ? const Color(0xFF7A3B12) : V2Colors.textMuted,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
