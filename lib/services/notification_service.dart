import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:versos_diarios/models/verse.dart';
import 'package:versos_diarios/services/bible_offline_service.dart';

/// Serviço de notificações locais diárias ("Pão Diário").
///
/// - Pede permissão ao usuário na primeira vez.
/// - Agenda notificação diária recorrente para as 08:00 AM.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int dailyId = 1001;
  static const String _channelId = 'versos_diarios_daily';
  static const String _channelName = 'Verso Diário';
  static const String _channelDescription =
      'Notificação matinal com o versículo do dia';

  bool _initialized = false;

  /// Inicializa o plugin, pede permissão e agenda o lembrete das 08:00.
  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );

    await requestPermission();

    _initialized = true;
    await scheduleDaily8am();
  }

  /// Pede permissão de notificação (Android 13+).
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin
    >();
    if (android == null) return true;
    final granted = await android.requestNotificationsPermission();
    return granted ?? true;
  }

  /// Corpo motivacional curto baseado no Versículo do Dia.
  String buildDailyBody([Verse? verse]) {
    final v = verse ?? BibleOfflineService.getVerseOfDay();
    return 'Sua palavra de ${v.theme.label.toLowerCase()} e esperança para hoje já está disponível: ${v.reference}.';
  }

  /// Agenda (ou reagenda) a notificação diária para exatamente 08:00 AM.
  Future<void> scheduleDaily8am({Verse? verse}) async {
    final body = buildDailyBody(verse);
    await _plugin.zonedSchedule(
      dailyId,
      '📖 Verso Diário',
      body,
      _next8am(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancela a notificação diária.
  Future<void> cancelDaily() => _plugin.cancel(dailyId);

  tz.TZDateTime _next8am() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
      0,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
