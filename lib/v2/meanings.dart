/// Nội dung diễn giải rút gọn cho các chỉ số thần số học.
///
/// Toàn bộ văn bản dưới đây được viết mới, ngắn gọn cho UI v2
/// (card/tóm tắt), KHÔNG dùng lại nguyên văn dữ liệu trong assets/data.
/// Các map có dạng "Tiêu đề|Mô tả" dùng [Meanings.titleOf] để tách
/// tiêu đề khi chỉ cần hiển thị phần đầu.
class Meanings {
  /// Số Chủ Đạo: tiêu đề + một câu mô tả cốt lõi.
  static const Map<int, String> lifePathTitle = {
    1: 'Người tiên phong|Độc lập, quyết đoán và luôn muốn dẫn đầu; bài học lớn nhất là lắng nghe và hợp tác thay vì làm mọi thứ một mình.',
    2: 'Người hoà giải|Nhạy cảm, khéo léo và giỏi kết nối; bạn mạnh nhất khi biết tin vào trực giác và đặt ranh giới cho bản thân.',
    3: 'Người truyền cảm hứng|Sôi nổi, sáng tạo và giàu năng lượng ngôn ngữ; cần rèn tính kiên trì để đi đến cùng với ý tưởng của mình.',
    4: 'Người xây nền tảng|Thực tế, kỷ luật và đáng tin cậy; bạn xây thành công bằng sự bền bỉ, nhưng đừng để sự cứng nhắc làm khó mình.',
    5: 'Người yêu tự do|Năng động, ham trải nghiệm và thích đổi mới; tự do là động lực sống, đi kèm với nhu cầu tự kỷ luật.',
    6: 'Người chăm sóc|Giàu tình cảm, có trách nhiệm và hướng về gia đình; học cách cho đi mà không quên chăm sóc chính mình.',
    7: 'Người chiêm nghiệm|Thích suy ngẫm, phân tích và tìm chiều sâu; con đường của bạn là tri thức và sự tĩnh lặng nội tâm.',
    8: 'Người điều hành|Tham vọng, giỏi tổ chức và nhạy bén với tiền bạc – quyền lực; thành công bền khi cân bằng vật chất với cảm xúc.',
    9: 'Người nhân ái|Lý tưởng, bao dung và hướng về cộng đồng; bạn hoàn thiện mình qua việc phụng sự và biết buông bỏ.',
    11: 'Người soi sáng (Master 11)|Trực giác rất mạnh và có khả năng truyền cảm hứng cho người khác; thử thách là giữ cân bằng cảm xúc trước áp lực của năng lượng lớn.',
    22: 'Người kiến tạo (Master 22)|Biến ý tưởng lớn thành kết quả cụ thể ở quy mô rộng; cần kỷ luật và kiên nhẫn để đi hết tham vọng của chính mình.',
    33: 'Người chữa lành (Master 33)|Trái tim hướng về cộng đồng, có sức ảnh hưởng bằng tình thương và sự tận tuỵ; bài học là cho đi đúng cách, không hy sinh quá mức.',
  };

  /// Số Sứ Mệnh (từ họ tên): mô tả ngắn về "việc phải làm" trong đời.
  static const Map<int, String> destinyShort = {
    1: 'Sứ mệnh dẫn dắt: chủ động mở đường và chịu trách nhiệm cho lựa chọn của mình.',
    2: 'Sứ mệnh kết nối: xây cầu nối giữa mọi người bằng sự tinh tế và kiên nhẫn.',
    3: 'Sứ mệnh lan toả: dùng lời nói, nghệ thuật và niềm vui để nâng đỡ tinh thần người khác.',
    4: 'Sứ mệnh xây dựng: tạo ra những hệ thống, nền tảng vững chắc và có ích lâu dài.',
    5: 'Sứ mệnh trải nghiệm: thay đổi, khám phá và truyền lại kinh nghiệm sống cho cộng đồng.',
    6: 'Sứ mệnh phụng sự: chăm lo gia đình và tạo cảm giác an toàn, ấm áp quanh mình.',
    7: 'Sứ mệnh tri thức: nghiên cứu, đúc kết và chia sẻ hiểu biết sâu sắc cho người khác.',
    8: 'Sứ mệnh thành tựu: gây dựng giá trị vật chất và dùng nguồn lực đó một cách khôn ngoan.',
    9: 'Sứ mệnh nhân đạo: cống hiến cho những mục tiêu lớn hơn lợi ích cá nhân.',
    11: 'Sứ mệnh soi sáng: dùng trực giác và tấm gương sống để thức tỉnh, truyền cảm hứng cho nhiều người.',
    22: 'Sứ mệnh kiến tạo lớn: biến tầm nhìn thành công trình, tổ chức hay giá trị để lại lâu dài.',
  };

  /// Số Linh Hồn (từ nguyên âm trong tên): khao khát sâu bên trong.
  static const Map<int, String> soulShort = {
    1: 'Bên trong khao khát được tự quyết, được công nhận và đứng ở vị trí xứng đáng.',
    2: 'Bên trong khao khát sự hoà hợp, được yêu thương và những mối quan hệ yên bình.',
    3: 'Bên trong khao khát được thể hiện mình, được vui sống và sáng tạo mỗi ngày.',
    4: 'Bên trong khao khát sự ổn định, trật tự và cảm giác an toàn lâu dài.',
    5: 'Bên trong khao khát tự do, đổi gió và những trải nghiệm không bị gò bó.',
    6: 'Bên trong khao khát một mái ấm trọn vẹn và được chăm sóc những người thân yêu.',
    7: 'Bên trong khao khát hiểu biết, không gian riêng và những khoảng lặng để chiêm nghiệm.',
    8: 'Bên trong khao khát thành công, vị thế và sự đủ đầy về vật chất.',
    9: 'Bên trong khao khát được cho đi, được sống có ý nghĩa và giúp ích cho đời.',
    11: 'Bên trong khao khát kết nối tâm linh và cảm giác được dẫn dắt bởi trực giác đúng đắn.',
    22: 'Bên trong khao khát tạo ra điều gì đó lớn lao, bền vững và vượt khỏi nhu cầu cá nhân.',
  };

  /// Số Nhân Cách (từ phụ âm trong tên): ấn tượng ban đầu với người khác.
  static const Map<int, String> personalityShort = {
    1: 'Người khác thấy bạn mạnh mẽ, thẳng thắn và có tố chất thủ lĩnh.',
    2: 'Người khác thấy bạn nhẹ nhàng, dễ gần và biết lắng nghe.',
    3: 'Người khác thấy bạn hoạt bát, hài hước và tràn đầy năng lượng.',
    4: 'Người khác thấy bạn chắc chắn, nguyên tắc và rất đáng tin.',
    5: 'Người khác thấy bạn linh hoạt, thú vị và khó đoán trước.',
    6: 'Người khác thấy bạn ấm áp, chu đáo và có trách nhiệm.',
    7: 'Người khác thấy bạn trầm tư, kín đáo và có chiều sâu.',
    8: 'Người khác thấy bạn tự tin, quyết đoán và có phong thái thành đạt.',
    9: 'Người khác thấy bạn thân thiện, bao dung và dễ tạo thiện cảm.',
    11: 'Người khác thấy bạn có sức hút đặc biệt, nhạy bén và khó nắm bắt.',
    22: 'Người khác thấy bạn điềm tĩnh, tầm vóc và làm việc gì cũng có hệ thống.',
  };

  /// Ngày Cá Nhân 1-9: "Tiêu đề buổi ngày|Lời khuyên ngắn".
  static const Map<int, String> personalDayInfo = {
    1: 'Ngày khởi đầu|Hợp để bắt đầu việc mới, chủ động liên lạc và ra quyết định dứt khoát.',
    2: 'Ngày lắng nghe|Đi chậm lại, ưu tiên đối thoại và tránh tranh luận hơn thua.',
    3: 'Ngày lan toả|Hợp gặp gỡ, sáng tạo và chăm chút hình ảnh cá nhân của bạn.',
    4: 'Ngày nền tảng|Tập trung việc thực tế, sắp xếp lại kế hoạch và kết thúc việc còn dang dở.',
    5: 'Ngày thay đổi|Linh hoạt đón nhận việc bất ngờ, tránh cam kết quá dài hạn trong hôm nay.',
    6: 'Ngày gia đình|Dành thời gian cho người thân và những việc nhà cần bạn có mặt.',
    7: 'Ngày chiêm nghiệm|Hợp học hỏi, đọc lại và tĩnh tâm hơn là mở rộng ra bên ngoài.',
    8: 'Ngày thành tựu|Xử lý dứt điểm việc quan trọng, mạnh dạn đề xuất và đàm phán.',
    9: 'Ngày buông bỏ|Hoàn tất, dọn dẹp và khép lại những chuyện cũ để chuẩn bị chu kỳ mới.',
  };

  /// Năm Cá Nhân 1-9: chủ đề chính của năm.
  static const Map<int, String> personalYearShort = {
    1: 'Năm khởi đầu chu kỳ 9 năm: gieo hạt mới, mạnh dạn bắt đầu hướng đi riêng.',
    2: 'Năm vun đắp quan hệ: kiên nhẫn, hợp tác và chờ hạt giống nảy mầm.',
    3: 'Năm mở rộng xã hội: giao lưu, học kỹ năng mới và thể hiện bản thân.',
    4: 'Năm xây nền: kỷ luật, sức khoẻ và tài chính cần được sắp xếp chắc chắn.',
    5: 'Năm thay đổi: nhiều biến động và cơ hội dịch chuyển, hãy linh hoạt đón nhận.',
    6: 'Năm trách nhiệm: gia đình, cam kết và những quyết định gắn bó lâu dài.',
    7: 'Năm nhìn lại: học hỏi, chiêm nghiệm và chuẩn bị cho bước nhảy tiếp theo.',
    8: 'Năm gặt hái: tập trung sự nghiệp, tiền bạc và những mục tiêu đo được kết quả.',
    9: 'Năm kết thúc chu kỳ: tổng kết, buông bỏ cái cũ để sẵn sàng cho hành trình mới.',
  };

  /// Tháng Cá Nhân theo cùng thang chủ đề với Năm Cá Nhân (dùng chung
  /// bộ mô tả rút gọn cho gọn và nhất quán).
  static const Map<int, String> personalMonthShort = personalYearShort;

  /// Tách phần tiêu đề (trước dấu '|') trong một entry của các map
  /// trên. Nếu entry không có '|' thì trả nguyên chuỗi; nếu không tìm
  /// thấy số [n] trong map thì trả chuỗi rỗng.
  static String titleOf(Map<int, String> m, int n) {
    final entry = m[n];
    if (entry == null) return '';
    final idx = entry.indexOf('|');
    return (idx >= 0 ? entry.substring(0, idx) : entry).trim();
  }

  /// Tách phần mô tả (sau dấu '|'); tiện cho UI hiển thị hai dòng.
  static String bodyOf(Map<int, String> m, int n) {
    final entry = m[n];
    if (entry == null) return '';
    final idx = entry.indexOf('|');
    return (idx >= 0 ? entry.substring(idx + 1) : '').trim();
  }
}
