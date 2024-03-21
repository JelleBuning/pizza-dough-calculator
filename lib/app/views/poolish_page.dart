import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/services/notification_service.dart';
import 'package:dough_calculator/app/services/page_service.dart';
import 'package:dough_calculator/app/widgets/checkbox_formfield.dart';
import 'package:dough_calculator/app/widgets/ingredient_widget.dart';
import 'package:dough_calculator/app/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PoolishPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime maxStartDate;
  const PoolishPage(
      {super.key, required this.startDate, required this.maxStartDate});

  @override
  State<PoolishPage> createState() => _PoolishPageState();
}

class _PoolishPageState extends State<PoolishPage> {
  final _formKey = GlobalKey<FormState>();
  int flourAmount = 300;
  int waterAmount = 300;
  int yeastAmount = 6;
  int honeyAmount = 6;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      appbar: AppBar(
        title: const Text('Make the poolish'),
        leading: IconButton(
          onPressed: () => showAlertDialog(context),
          icon: const Icon(Icons.close_rounded),
          splashRadius: 25,
        ),
      ),
      content: SingleChildScrollView(
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
                                      '${DateFormat("EEEE").format(widget.startDate)}, between '),
                              TextSpan(
                                  text: DateFormat("HH:mm")
                                      .format(widget.startDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                  text: DateFormat("HH:mm")
                                      .format(widget.maxStartDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
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
                        initialTime: TimeOfDay(hour: (widget.startDate.hour), minute: 0),
                      ).then((time) {
                          if (time != null) {
                          var notifyAt = DateTime(widget.startDate.year, widget.startDate.month, widget.startDate.day, time.hour, time.minute) ;
                          NotificationService.createNewScheduledNotification(
                            'Reminder',
                            "It's time to create your poolish.",
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
                      IngredientWidget(title: 'Flour (g)', value: flourAmount),
                      IngredientWidget(title: 'Water (g)', value: waterAmount),
                      IngredientWidget(
                          title: 'Instant yeast (g)', value: yeastAmount),
                      IngredientWidget(title: 'Honey (g)', value: honeyAmount),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Steps:', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(
                    height: 2.5,
                  ),
                  CheckboxFormField(
                    title: Text('Mix all the ingredients',
                        style: TextStyle(color: Colors.grey[300])),
                    validator: (value) {
                      if (value == null || !value) {
                        return 'must mix all ingredients';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
            var mixedAt = DateTime.now();
            LocalStorageService.poolishMixedAt.then((value) {
              DateTime? date = value;
              if (value == null) { // First visit
                date = mixedAt;
                NotificationService.createNewScheduledAlarm(
                    'Poolish done',
                    'Your poolish is ready to transferred to the fridge!',
                    mixedAt
                        .add(const Duration(hours: 1))); // poolish takes 1 hour
              }
              LocalStorageService.setPoolishMixedAt(date).then((value) {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        PageService.getRoomTemperaturePage(context, date!),
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
            Navigator.pop(context);
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
