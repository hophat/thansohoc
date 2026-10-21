import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/app_color.dart';

/// Design system cho các tính năng MỚI (v2).
/// Giữ DNA đỏ – vàng của app cũ (TSHColors) nhưng theo design board đã duyệt:
/// nền gradient đỏ sâu, card kính viền gold, số hero Playfair Display,
/// chữ Be Vietnam Pro, nút chính gradient gold, bo góc 16–18, chip pill.
class V2Colors {
  static Color get gold => const Color(0xFFEDBE72);
  static Color get goldLight => const Color(0xFFFAE9B1);
  static Color get redDeep => const Color(0xFF9B150E);
  static Color get redAccent => TSHColors().primaryColor; // #E94944
  static Color get bgTop => const Color(0xFF8F130C);
  static Color get bgMid => const Color(0xFF6E0D08);
  static Color get bgBottom => const Color(0xFF4A0805);
  static Color get textMain => const Color(0xFFFFF6DE);
  static Color get textMuted => const Color(0xFFD8C58E);
  static Color get textFaint => const Color(0xFFCBB87F);
  static Color get darkOnGold => const Color(0xFF5C0E08);
}

class V2Theme {
  static LinearGradient get pageGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [V2Colors.bgTop, V2Colors.bgMid, V2Colors.bgBottom],
        stops: const [0.0, 0.45, 1.0],
      );

  static LinearGradient get goldGradient =>
      LinearGradient(colors: TSHColors().gradiantBtnColor);

  static LinearGradient get ringGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE94944), Color(0xFFC72C25)],
      );

  static BoxDecoration glassCard({double radius = 18}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: V2Colors.gold.withOpacity(0.55)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            V2Colors.goldLight.withOpacity(0.14),
            V2Colors.goldLight.withOpacity(0.05),
          ],
        ),
      );

  static BoxDecoration solidGoldCard({double radius = 18}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V2Colors.goldLight, V2Colors.gold],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            offset: const Offset(0, 10),
            blurRadius: 22,
          ),
        ],
      );

  // ---------- Text styles ----------
  static TextStyle heroNumber(double size) => GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: V2Colors.goldLight,
        height: 1.0,
      );

  static TextStyle screenTitle() => GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: V2Colors.goldLight,
        height: 1.3,
      );

  static TextStyle cardTitle({Color? color}) => GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? V2Colors.goldLight,
      );

  static TextStyle body({Color? color, double size = 13}) =>
      GoogleFonts.beVietnamPro(
        fontSize: size,
        height: 1.55,
        color: color ?? V2Colors.textMain,
      );

  static TextStyle muted({double size = 11.5}) => GoogleFonts.beVietnamPro(
        fontSize: size,
        height: 1.5,
        color: V2Colors.textMuted,
      );

  static TextStyle label() => GoogleFonts.beVietnamPro(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: V2Colors.gold,
      );
}

/// Tách chuỗi Meanings dạng "Tiêu đề|Mô tả" một cách an toàn.
String meaningTitle(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  return raw.split('|').first.trim();
}

String meaningDesc(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  final parts = raw.split('|');
  return parts.length > 1 ? parts.sublist(1).join('|').trim() : '';
}

String formatDateVN(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// Scaffold nền gradient đỏ sâu + AppBar trong suốt (màn đẩy, có nút back).
class V2Scaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const V2Scaffold({Key? key, required this.title, required this.child, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: V2Colors.goldLight),
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: V2Colors.goldLight,
          ),
        ),
        actions: actions,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: V2Theme.pageGradient),
        child: SafeArea(child: child),
      ),
    );
  }
}

/// Nút chính: gradient gold, chữ đỏ đậm.
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GoldButton({Key? key, required this.label, required this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          decoration: BoxDecoration(
            gradient: V2Theme.goldGradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: V2Colors.darkOnGold),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: V2Colors.darkOnGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nút viền gold (phụ).
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GhostButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: V2Colors.gold, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: V2Colors.goldLight,
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip pill chọn lựa.
class V2Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const V2Chip({Key? key, required this.label, this.selected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected
                ? const LinearGradient(colors: [Color(0xFFC72C25), Color(0xFFE94944)])
                : null,
            color: selected ? null : const Color(0xFF3A0F0B),
            border: Border.all(
              color: selected ? V2Colors.gold : const Color(0xFF7A2A20),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : const Color(0xFFF3E3B2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vòng tròn số hero như design board.
class NumberRing extends StatelessWidget {
  final int number;
  final String? label;
  final double size;

  const NumberRing({Key? key, required this.number, this.label, this.size = 138})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: V2Colors.gold, width: 3),
        gradient: const RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.9,
          colors: [Color(0xFFC72C25), Color(0xFF7E0F09)],
        ),
        boxShadow: [
          BoxShadow(color: V2Colors.gold.withOpacity(0.16), spreadRadius: 8),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, 14),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$number', style: V2Theme.heroNumber(size * 0.42)),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label!.toUpperCase(),
                style: GoogleFonts.beVietnamPro(
                  fontSize: size * 0.075,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: const Color(0xFFFFD98A),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Ô chỉ số trong lưới chi tiết.
class IndexTile extends StatelessWidget {
  final String label;
  final int number;
  final String title;
  final String desc;

  const IndexTile({
    Key? key,
    required this.label,
    required this.number,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: V2Colors.goldLight.withOpacity(0.09),
        border: Border.all(color: V2Colors.gold.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: V2Colors.gold,
                  ),
                ),
              ),
              Text('$number', style: V2Theme.heroNumber(24)),
            ],
          ),
          if (title.isNotEmpty)
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: V2Colors.textMain,
              ),
            ),
          if (desc.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(desc, style: V2Theme.muted(size: 11)),
            ),
        ],
      ),
    );
  }
}

/// Thanh meter 0–100 cho màn tương hợp.
class MeterBar extends StatelessWidget {
  final String label;
  final int value;

  const MeterBar({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: V2Colors.gold,
                  ),
                ),
              ),
              Text('$v%', style: V2Theme.muted(size: 12)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Container(
              height: 8,
              color: V2Colors.goldLight.withOpacity(0.18),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: v / 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFEDBE72), Color(0xFFE94944)]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
