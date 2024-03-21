import 'package:dough_calculator/app/models/dough_config.dart';
import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/services/notification_service.dart';
import 'package:dough_calculator/app/services/page_service.dart';
import 'package:dough_calculator/app/views/home_page.dart';
import 'package:dough_calculator/app/widgets/checkbox_formfield.dart';
import 'package:dough_calculator/app/widgets/ingredient_widget.dart';
import 'package:dough_calculator/app/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinalMixPage extends StatefulWidget {
  final DateTime endDate;
  const FinalMixPage({super.key, required this.endDate});

  @override
  State<FinalMixPage> createState() => _FinalMixPageState();
}

class _FinalMixPageState extends State<FinalMixPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      appbar: AppBar(
        title: const Text('Final mix'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
                splashRadius: 25,
              )
            : IconButton(
                onPressed: () => showAlertDialog(context),
                icon: const Icon(Icons.close_rounded, size: 22),
                splashRadius: 25,
              ),
      ),
      content: FutureBuilder<DoughConfig?>(
        future: LocalStorageService.dougConfig,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recommended time to start:',
                                  style: TextStyle(color: Colors.grey[600])),
                              const SizedBox(
                                height: 2.5,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${DateFormat("EEEE").format(snapshot.data!.readyAt!)}, between '),
                                    TextSpan(
                                        text: DateFormat("HH:mm").format(
                                            snapshot.data!.readyAt!.subtract(
                                                const Duration(hours: 3))),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                        text: DateFormat("HH:mm").format(
                                            snapshot.data!.readyAt!.subtract(
                                                const Duration(hours: 2))),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => IconButton(
                      onPressed: () => showTimePicker(
                        helpText: "Add reminder",
                        context: context,
                        builder: (context, child) {
                          return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!);
                        },
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        initialTime: TimeOfDay(hour: (widget.endDate.hour), minute: 0),
                      ).then((time) {
                          if (time != null) {
                          var notifyAt = DateTime(widget.endDate.year, widget.endDate.month, widget.endDate.day, time.hour, time.minute) ;
                          NotificationService.createNewScheduledNotification(
                            'Reminder',
                            "Time to start making your pizza's",
                            notifyAt
                          );
                          NotificationService.showToastMessage(context, "Reminder added");
                        }},
                      ),
                      icon: const Icon(
                        Icons.schedule,
                        size: 20,
                      ),
                      splashRadius: 25,
                      color: Colors.grey[400],
                    ),
                            icon: const Icon(
                              Icons.schedule,
                              size: 20,
                            ),
                            splashRadius: 25,
                            color: Colors.grey[400],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            IngredientWidget(
                                title: 'Flour (g)',
                                value: snapshot.data?.flour == null
                                    ? null
                                    : snapshot.data!.flour! - 300),
                            IngredientWidget(
                                title: 'Water (g)',
                                value: snapshot.data?.water == null
                                    ? null
                                    : snapshot.data!.water! - 300),
                            IngredientWidget(
                                title: 'Salt (g)', value: snapshot.data?.salt),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Steps:',
                            style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(
                          height: 2.5,
                        ),
                        CheckboxFormField(
                          title: Text('Add the ingredients to the poolish',
                              style: TextStyle(color: Colors.grey[300])),
                          validator: (value) {
                            if (value == null || !value) {
                              return 'must mix all ingredients';
                            }
                            return null;
                          },
                        ),
                        CheckboxFormField(
                          title: Text('Cover and let rest for 20-30 min',
                              style: TextStyle(color: Colors.grey[300])),
                          validator: (value) {
                            if (value == null || !value) {
                              return 'must cover and let rest';
                            }
                            return null;
                          },
                        ),
                        CheckboxFormField(
                          title: Text(
                              'Knead dough and form into ball (still sticky)',
                              style: TextStyle(color: Colors.grey[300])),
                          validator: (value) {
                            if (value == null || !value) {
                              return 'must knead dough';
                            }
                            return null;
                          },
                        ),
                        CheckboxFormField(
                          title: Text(
                              'Cover and let rest for 15-20 mintutes',
                              style: TextStyle(color: Colors.grey[300])),
                          validator: (value) {
                            if (value == null || !value) {
                              return 'must be covered and rested';
                            }
                            return null;
                          },
                        ),
                        CheckboxFormField(
                          title: Text(
                              'Split into portions and place in dough container',
                              style: TextStyle(color: Colors.grey[300])),
                          validator: (value) {
                            if (value == null || !value) {
                              return 'must be split by portion weight';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: const Text('Next'),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var createdAt = DateTime.now();
            LocalStorageService.ballsCreatedAt.then((value) {
              var date = value;
              if (value == null) { // First visit
                date = createdAt;
                NotificationService.createNewScheduledAlarm(
                    'Ready to bake',
                    "Your dough is ready for the oven!",
                    createdAt.add(const Duration(hours: 1))); // poolish takes 1 hour
              }
              LocalStorageService.setBallsCreatedAt(date).then((value) {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => PageService.getBallRestPage(context, date!),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero));
              });
            });
          }
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Start over"),
      content: const Text(
          "Are you sure you want to start over, closing resets all timers and settings."),
      actions: [
        ElevatedButton(
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Ok"),
          ),
          onPressed: () {
            LocalStorageService.resetAll();
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Cancel"),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
