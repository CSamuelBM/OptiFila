import 'dart:io'; // Para chequear el sistema operativo
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar toque en notificación
      },
    );

    // Llamamos a pedir permisos justo después de inicializar
    await requestPermissions();
  }

  static Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // Pedir permiso específicamente para Android 13+ (API 33+)
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      // Pedir permiso para iOS
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
      _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_turnos_id',
      'Turnos',
      channelDescription: 'Notificaciones sobre el estado de tus turnos',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, platformDetails);
  }
}