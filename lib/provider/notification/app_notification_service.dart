import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Pages/hangngay/zodiac_menu.dart';
import '../navigator_service.dart';


part 'noti_config.dart';

class AppNotiService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  String _token = '';
  String get fcmToken => _token;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _token = await _firebaseMessaging.getToken() ?? _token;
    debugPrint("FCM TOKEN: $fcmToken");
    initLocalNotification();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.of(NavigatorService.I.context).push(MaterialPageRoute(builder: (_){
        return ZodiacMenu();
      }));
    });
  }

  Future<void> initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(settings, onDidReceiveNotificationResponse: (res){
      Navigator.of(NavigatorService.I.context).push(MaterialPageRoute(builder: (_){
        return ZodiacMenu();
      }));
    });
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage, onDone: () {
      debugPrint("FirebaseMessaging.onMessage: Done");
    }, onError: (e) {
      debugPrint("FirebaseMessaging.onMessage: Error => $e");
    });

  }

  @pragma("vm:entry-point")
  Future<void> _handleForegroundMessage(RemoteMessage? message) async {
    print('message notify: _handleForegroundMessage $message');
    final notification = message?.notification;
    // if(message?.data == null) return;
    if (message == null) return;
    try {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      final platformChannelSpecifics = NotificationDetails(
          android: AndroidNoti.notificationDetails(sound: ''),
          iOS: const DarwinNotificationDetails(sound: ''));
      await _localNotifications.show(
          notification.hashCode,
          title,
          body,
          platformChannelSpecifics,
          payload: jsonEncode(message.toMap()));

    } catch (e) {
      debugPrint("[Error] when _handleForegroundMessage\n => $e");
    }
  }
}

@pragma("vm:entry-point")
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  /// ! hot fix duplicate from server
  print('message notify: handleBackgroundMessage');
  int msgId = int.tryParse(message.data["msg_id"].toString()) ?? 0;

  final androidPlatformChannelSpecifics = AndroidNoti.notificationDetails(sound: message.data["sound"].toString().split(".").first);
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails(sound: '');
  final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  /// * temp hide
  // final androidPlatformChannelSpecifics = AndroidNoti.notificationDetails();
  // const iOSPlatformChannelSpecifics = DarwinNotificationDetails(sound: 'common_noti.aiff');
  final title = message.notification?.title?? "";
  final body = message.notification?.body ?? "";
  try {
    await FlutterLocalNotificationsPlugin().show(
      msgId,
      title,
      body,
      platformChannelSpecifics,
      payload: message.data["data"],
    );

  } catch (e) {
    debugPrint("[Error] when _handleBackgroundMessage\n => $e");
  }
}
