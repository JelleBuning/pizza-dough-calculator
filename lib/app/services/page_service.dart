import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/services/notification_service.dart';
import 'package:dough_calculator/app/views/final_mix_page.dart';
import 'package:dough_calculator/app/views/home_page.dart';
import 'package:dough_calculator/app/views/timer_page.dart';
import 'package:flutter/material.dart';

class PageService {
  static StatefulWidget getRoomTemperaturePage(
      BuildContext context, DateTime mixedAt) {
    int duration = 1;
    return TimerPage(
      title: 'Leave at room temperature',
      subTitle: 'Leave at room temperature for one hour:',
      duration: Duration(hours: duration),
      notifyAt: mixedAt.add(Duration(hours: duration)),
      onPressedCallback: (DateTime pressedAt) {
        LocalStorageService.setInFridgeAt(pressedAt).then((value) {
          NotificationService.createNewScheduledAlarm(
            'Rising done',
            'The dough has finished rising in the fridge.',
            pressedAt.add(const Duration(hours: 16)));
          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    getFridgePage(context, pressedAt)),
          );
        });
      },
    );
  }

  static StatefulWidget getFridgePage(
      BuildContext context, DateTime inFridgeAt) {
    int duration = 16;
    return TimerPage(
      title: 'Refrigerate for 16 to 24 hours',
      subTitle: 'Dough ready between:',
      duration: Duration(hours: duration),
      notifyAt: inFridgeAt.add(Duration(hours: duration)),
      maxDateTime: inFridgeAt.add(const Duration(hours: 24)),
      onPressedCallback: (DateTime pressedAt) {
        LocalStorageService.setOutOfFridgeAt(pressedAt).then((value) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  FinalMixPage(endDate: DateTime.now()),
            ),
          );
        });
      },
    );
  }

  static StatefulWidget getBallRestPage(
      BuildContext context, DateTime createdAt) {
    return TimerPage(
      title: 'Let dough balls rest',
      subTitle: 'Dough ready between:',
      doneText: "Dough\n ready",
      btnDoneText: "Start over",
      duration: const Duration(hours: 1),
      notifyAt: createdAt.add(const Duration(hours: 1)),
      maxDateTime: createdAt.add(const Duration(hours: 2)),
      onPressedCallback: (DateTime pressedAt) {
        LocalStorageService.resetAll().then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const HomePage(),
            ),
            (route) => false,
          );
        });
      },
    );
  }
}
