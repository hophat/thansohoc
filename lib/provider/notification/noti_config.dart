part of 'app_notification_service.dart';


class AndroidNoti{
  const AndroidNoti._();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High importance notifications',
    description: "This channel is used for important notifications",
    importance: Importance.max,
  );

  static AndroidNotificationDetails notificationDetails({required String sound}) {
    return AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      icon: '@drawable/ic_noti',
      color: TSHColors().primaryTextColor,
      importance: _androidChannel.importance,
      sound: RawResourceAndroidNotificationSound( kDebugMode ? sound : ''),
    );
  }
}
