import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dough_calculator/app/models/local_variables.dart';
import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/services/notification_service.dart';
import 'package:dough_calculator/app/services/page_service.dart';
import 'package:dough_calculator/app/views/final_mix_page.dart';
import 'package:dough_calculator/app/views/home_page.dart';
import 'package:dough_calculator/app/views/poolish_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await NotificationService.initializeLocalNotifications();
      await NotificationService.initializeIsolateReceivePort();
    }
  }

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var scaffoldColor = const Color.fromARGB(255, 38, 38, 38);
  var onSurfaceColor = Color.fromARGB(255, 64, 64, 64);
  @override
  void initState() {
    NotificationService.startListeningNotificationEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dough calculator',
      debugShowCheckedModeBanner: false,
      navigatorKey: App.navigatorKey,
      home: FutureBuilder<LocalVariables>(
        future: getLocalVariables(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var poolishMixedAt = snapshot.data!.poolishMixedAt;
            var inFridgeAt = snapshot.data!.inFridgeAt;
            var outOfFridgeAt = snapshot.data!.outOfFridgeAt;
            var ballsCreatedAt = snapshot.data!.ballsCreatedAt;
            var recipeEndDate = snapshot.data!.recipeEndDate;
            if (ballsCreatedAt != null) {
              return PageService.getBallRestPage(context, ballsCreatedAt);
            } else if (outOfFridgeAt != null) {
              return FinalMixPage(endDate: DateTime.now());
            } else if (inFridgeAt != null &&
                inFridgeAt.isBefore(DateTime.now())) {
              return PageService.getFridgePage(context, inFridgeAt);
            } else if (poolishMixedAt != null) {
              return PageService.getRoomTemperaturePage(
                  context, poolishMixedAt);
            } else if (recipeEndDate != null) {
              var startDate = recipeEndDate.subtract(const Duration(hours: 28));
              var startMaxDate =
                  recipeEndDate.subtract(const Duration(hours: 20));
              return PoolishPage(
                  startDate: startDate, maxStartDate: startMaxDate);
            }
            return const HomePage();
          }
          return const Scaffold(body: SizedBox.shrink());
        },
      ),
      theme: ThemeData.dark(
        useMaterial3: false,
      ).copyWith(
          scaffoldBackgroundColor: scaffoldColor,
          snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[800]),
          cardColor: const Color.fromARGB(255, 51, 51, 51),
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.red,
            onPrimary: Colors.white, // header text color
            onSurface: Colors.grey[100],
            error: Colors.red,
            
          ),
          dividerColor: onSurfaceColor,
          dividerTheme: const DividerThemeData(thickness: 0.5),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            shape: Border(
              bottom: BorderSide(
                color: onSurfaceColor,
                width: 1,
              ),
            ),
            toolbarHeight: 80,
            elevation: 0,
          ),
          dialogBackgroundColor: scaffoldColor,
          datePickerTheme: DatePickerThemeData(
            backgroundColor: scaffoldColor,
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: scaffoldColor,
            dialTextColor: Colors.white,
            hourMinuteTextColor: Colors.white),
          ),
    );
  }

  // Theme(
  //                             data: Theme.of(context).copyWith(
  //                               colorScheme: const ColorScheme.light(
  //                                 primary:
  //                                     Colors.red, // header background color
  //                                 onPrimary: Colors.white, // header text color
  //                                 onSurface: Color.fromARGB(
  //                                     255, 216, 216, 216), // body text color
  //                               ),
  //                             ),
  //                             child: child!,
  //                           );

  Future<LocalVariables> getLocalVariables() async {
    var poolishMixedAt = await LocalStorageService.poolishMixedAt;
    var inFridgeAt = await LocalStorageService.inFridgeAt;
    var outOfFridgeAt = await LocalStorageService.outOfFridgeAt;
    var ballsCreatedAt = await LocalStorageService.ballsCreatedAt;
    var doughConfig = await LocalStorageService.dougConfig;
    return LocalVariables(poolishMixedAt, inFridgeAt, outOfFridgeAt,
        ballsCreatedAt, doughConfig?.readyAt);
  }

  void requestPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
