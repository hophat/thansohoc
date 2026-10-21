/// Analytics đã được vô hiệu hoá (no-op) từ khi app chuyển sang
/// offline và gỡ Firebase. File cũ chỉ còn là code đã comment toàn bộ;
/// giữ lại stub này để mọi tham chiếu (nếu có) vẫn biên dịch được mà
/// không gửi bất kỳ dữ liệu nào ra mạng.
class AnalyticsService {
  AnalyticsService._();

  static AnalyticsService? _instance;

  static AnalyticsService get I {
    _instance ??= AnalyticsService._();
    return _instance!;
  }
}
