import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../meanings.dart';
import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';

/// Chia sẻ kết quả dạng ảnh story dọc 9:16 (tính năng v2):
/// card vẽ bằng widget, chụp PNG bằng RepaintBoundary rồi share qua share_plus.
class ShareStoryScreen extends StatefulWidget {
  final TSHProfile profile;

  const ShareStoryScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ShareStoryScreen> createState() => _ShareStoryScreenState();
}

class _ShareStoryScreenState extends State<ShareStoryScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _sharing = false;

  TSHProfile get _p => widget.profile;

  String get _summary {
    final lp = NumerologyEngine.lifePath(_p.birthDate);
    final nn = NumerologyEngine.fromName(_p.name);
    final title = meaningTitle(Meanings.lifePathTitle[lp]);
    return '✦ Thần Số Học ✦\n'
        '${_p.name} · Sinh ngày ${formatDateVN(_p.birthDate)}\n'
        'Số chủ đạo: $lp${title.isEmpty ? '' : ' — $title'}\n'
        'Sứ mệnh: ${nn.destiny} · Linh hồn: ${nn.soulUrge} · '
        'Nhân cách: ${nn.personality}';
  }

  Future<void> _shareImage() async {
    setState(() => _sharing = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('boundary not ready');
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('encode failed');
      final file = File(
          '${Directory.systemTemp.path}/tsh_story_${_p.id.isEmpty ? 'profile' : _p.id}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)], text: _summary);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Chưa chia sẻ được ảnh, bạn thử lại nhé.')),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _copySummary() async {
    await Clipboard.setData(ClipboardData(text: _summary));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép tóm tắt kết quả')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lp = NumerologyEngine.lifePath(_p.birthDate);
    final nn = NumerologyEngine.fromName(_p.name);
    final title = meaningTitle(Meanings.lifePathTitle[lp]);
    final desc = meaningDesc(Meanings.lifePathTitle[lp]);

    return V2Scaffold(
      title: 'Chia sẻ kết quả',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: RadialGradient(
                          center: Alignment(0, -0.35),
                          radius: 1.1,
                          colors: [Color(0xFFA3160F), Color(0xFF4A0805)],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: V2Colors.gold, width: 2),
                        ),
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'THẦN SỐ HỌC',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                                color: const Color(0xFFFFD98A),
                              ),
                            ),
                            const SizedBox(height: 14),
                            NumberRing(
                                number: lp, label: 'Số chủ đạo', size: 128),
                            const SizedBox(height: 12),
                            if (title.isNotEmpty)
                              Text(
                                title,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: V2Colors.goldLight,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (desc.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                desc,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10.5,
                                  height: 1.5,
                                  color: const Color(0xFFF3E3B2),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              'Sứ mệnh ${nn.destiny} · Linh hồn ${nn.soulUrge} '
                              '· Nhân cách ${nn.personality}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10.5,
                                color: V2Colors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_p.name} · ${formatDateVN(_p.birthDate)}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10.5,
                                color: V2Colors.textFaint,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '✦ Tải app Thần Số Học ✦',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: V2Colors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GoldButton(
              label: _sharing ? 'Đang tạo ảnh…' : 'Chia sẻ ảnh',
              icon: Icons.share,
              onPressed: _sharing ? null : _shareImage,
            ),
            const SizedBox(height: 10),
            GhostButton(label: 'Sao chép tóm tắt', onPressed: _copySummary),
            const SizedBox(height: 10),
            Text(
              'Ảnh dọc 9:16 — hợp đăng Story TikTok / Facebook / Zalo.',
              style: V2Theme.muted(size: 11),
            ),
          ],
        ),
      ),
    );
  }
}
