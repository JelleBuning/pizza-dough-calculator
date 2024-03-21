import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:dough_calculator/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              enableVibration: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.red,
              ledColor: Colors.red),
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      // print(
      //     'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      if (receivePort == null) {
        // print(
        //     'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          // print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }

  static Future<void> executeLongTaskInBackground() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, // -1 is replaced by a random number
        channelKey: 'alerts',
        title: 'Huston! The eagle has landed!',
        body: "A small step for a man, but a giant to Flutter's community!",
        notificationLayout: NotificationLayout.Default,
        payload: {'notificationId': '1234567890'},
      ),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'View'),
      ],
    );
  }

  static Future<void> createNewScheduledAlarm(
      String title, String body, DateTime notifyAt) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar.fromDate(
        date: notifyAt,
        preciseAlarm: true,
      ),
      content: NotificationContent(
        id: -1, // -1 is replaced by a random number
        channelKey: 'alerts',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: {'notificationId': '1234567890'},
        category: NotificationCategory.Alarm,
        criticalAlert: true,
      ),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'View'),
      ],
    );
  }

  static Future<void> createNewScheduledNotification(
      String title, String body, DateTime notifyAt) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar.fromDate(
        date: notifyAt,
        preciseAlarm: true,
      ),
      content: NotificationContent(
        id: -1, // -1 is replaced by a random number
        channelKey: 'alerts',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: {'notificationId': '1234567890'},
      ),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'View'),
      ],
    );
  }

  static void removeAllNotifications(){
    AwesomeNotifications().cancelAll();
    AwesomeNotifications().cancelAllSchedules();
  }

  static void showToastMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        behavior: SnackBarBehavior.floating,

      ),
    );
  }
}
