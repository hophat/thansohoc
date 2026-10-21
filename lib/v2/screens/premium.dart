import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../v2_theme.dart';

/// Paywall Premium (tính năng v2) — giao diện theo design board.
/// Thanh toán thật chưa tích hợp: nút mua mở dialog thông báo sắp ra mắt.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  static const List<String> _benefits = [
    'Diễn giải sâu từng chỉ số (Sứ mệnh, Linh hồn…)',
    'Tương hợp cặp đôi không giới hạn',
    'Hồ sơ gia đình không giới hạn',
    'Dự báo Năm / Tháng cá nhân chi tiết',
    'Không quảng cáo',
  ];

  void _comingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF6E0D08),
        title: Text('Sắp ra mắt',
            style: GoogleFonts.beVietnamPro(
                color: V2Colors.goldLight, fontWeight: FontWeight.w700)),
        content: Text(
          'Tính năng thanh toán sắp ra mắt. Cảm ơn bạn đã quan tâm tới '
          'Thần Số Học Premium!',
          style: GoogleFonts.beVietnamPro(color: V2Colors.textMain),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Đã hiểu', style: TextStyle(color: V2Colors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return V2Scaffold(
      title: 'Thần Số Học Premium',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            Text('✦', style: V2Theme.heroNumber(44)),
            const SizedBox(height: 8),
            Text(
              'Mở khoá toàn bộ\nbản đồ cuộc đời bạn',
              style: V2Theme.screenTitle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: V2Theme.glassCard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _benefits
                    .map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('✓ ',
                                style: GoogleFonts.beVietnamPro(
                                    color: V2Colors.gold,
                                    fontWeight: FontWeight.w700)),
                            Expanded(
                              child: Text(b,
                                  style:
                                      V2Theme.body(size: 12.5, color: const Color(0xFFF3E3B2))),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _priceCard(
              context,
              title: 'Gói Năm',
              price: '299.000₫',
              note: '≈ 25.000₫/tháng — tiết kiệm 58% · Dùng thử 7 ngày',
              highlight: true,
            ),
            const SizedBox(height: 10),
            _priceCard(
              context,
              title: 'Gói Tháng',
              price: '59.000₫',
              note: 'Huỷ bất cứ lúc nào',
              highlight: false,
            ),
            const SizedBox(height: 18),
            GoldButton(
              label: 'Dùng thử 7 ngày miễn phí',
              onPressed: () => _comingSoon(context),
            ),
            const SizedBox(height: 10),
            Text(
              'Giá tham chiếu thị trường Việt Nam.',
              style: V2Theme.muted(size: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceCard(
    BuildContext context, {
    required String title,
    required String price,
    required String note,
    required bool highlight,
  }) {
    return InkWell(
      onTap: () => _comingSoon(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: highlight
            ? V2Theme.solidGoldCard(radius: 16)
            : V2Theme.glassCard(radius: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: highlight ? V2Colors.darkOnGold : V2Colors.textMain,
                    ),
                  ),
                ),
                if (highlight)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B150E),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'ĐÁNG GIÁ NHẤT',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: V2Colors.goldLight,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  price,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: highlight ? const Color(0xFF9B150E) : V2Colors.goldLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              note,
              style: highlight
                  ? GoogleFonts.beVietnamPro(
                      fontSize: 11.5, color: const Color(0xFF7A3B12))
                  : V2Theme.muted(size: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}
