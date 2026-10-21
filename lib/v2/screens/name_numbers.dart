import 'package:flutter/material.dart';

import '../meanings.dart';
import '../numerology_engine.dart';
import '../profile_store.dart';
import '../v2_theme.dart';
import 'compatibility.dart';
import 'share_story.dart';

/// Chi tiết chỉ số của một hồ sơ: vòng Số chủ đạo + lưới 6 chỉ số
/// (Sứ mệnh, Linh hồn, Nhân cách, Ngày sinh, Thái độ, Trưởng thành).
class NameNumbersScreen extends StatelessWidget {
  final TSHProfile profile;

  const NameNumbersScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dob = profile.birthDate;
    final lifePath = NumerologyEngine.lifePath(dob);
    final nameNums = NumerologyEngine.fromName(profile.name);
    final birthDay = NumerologyEngine.birthDay(dob);
    final attitude = NumerologyEngine.attitude(dob);
    final maturity = NumerologyEngine.maturity(lifePath, nameNums.destiny);

    final lpRaw = Meanings.lifePathTitle[lifePath];
    final lpTitle = meaningTitle(lpRaw);
    final lpDesc = meaningDesc(lpRaw);

    Widget tile(String label, int number, Map<int, String> map) {
      final raw = map[number];
      return IndexTile(
        label: label,
        number: number,
        title: meaningTitle(raw),
        desc: meaningDesc(raw),
      );
    }

    return V2Scaffold(
      title: profile.name,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            Text(
              '${profile.relation.isEmpty ? 'Hồ sơ' : profile.relation} · '
              'Sinh ngày ${formatDateVN(dob)}',
              style: V2Theme.muted(size: 12),
            ),
            const SizedBox(height: 14),
            NumberRing(number: lifePath, label: 'Số chủ đạo', size: 142),
            const SizedBox(height: 12),
            if (lpTitle.isNotEmpty)
              Text(
                lpTitle,
                style: V2Theme.cardTitle(),
                textAlign: TextAlign.center,
              ),
            if (lpDesc.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                lpDesc,
                style: V2Theme.muted(size: 12.5),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.12,
              children: [
                tile('Sứ mệnh', nameNums.destiny, Meanings.destinyShort),
                tile('Linh hồn', nameNums.soulUrge, Meanings.soulShort),
                tile('Nhân cách', nameNums.personality,
                    Meanings.personalityShort),
                tile('Ngày sinh', birthDay, Meanings.lifePathTitle),
                tile('Thái độ', attitude, Meanings.lifePathTitle),
                tile('Trưởng thành', maturity, Meanings.lifePathTitle),
              ],
            ),
            const SizedBox(height: 20),
            GoldButton(
              label: 'Chia sẻ kết quả',
              icon: Icons.share,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ShareStoryScreen(profile: profile)),
              ),
            ),
            const SizedBox(height: 10),
            GhostButton(
              label: 'Xem tương hợp với người khác ♥',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CompatibilityScreen(initialA: profile)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
