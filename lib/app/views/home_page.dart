import 'package:dough_calculator/app/models/dough_config.dart';
import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:dough_calculator/app/views/poolish_page.dart';
import 'package:dough_calculator/app/widgets/ingredient_widget.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime? _startDate;
  late DateTime? _startMaxDate;
  late DateTime? _finishMaxDate;

  @override
  void initState() {
    var finishDate =
        DateTime.now().add(const Duration(hours: 17)).copyWith(minute: 0);
    setDateInput(finishDate);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        String initialValue = '4';
        _inputController.text = initialValue;
        setValues(initialValue);
      },
    );
  }

  int totalFlour = 0;
  int totalWater = 0;
  int totalSalt = 0;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      appbar: AppBar(
        title: const Text('Dough calculator'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune_rounded,
                color: Colors.grey[300],
              ),
              splashRadius: 25,
            ),
          )
        ],
      ),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Amount required';
                              }
                              return null;
                            },
                            controller: _inputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'People (4 - 12)',
                            ),
                            onTapOutside: (event) {
                              var val = _inputController.text;
                              if (val != "") {
                                var amount = int.parse(val);
                                _inputController.text = amount < 4
                                    ? "4"
                                    : amount > 12
                                        ? "12"
                                        : amount.toString();
                                setValues(_inputController.text);
                              }
                            },
                            onChanged: (value) {
                              setValues(value);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _dateInputController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Due required';
                              }
                              return null;
                            },
                            focusNode: AlwaysDisabledFocusNode(),
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: _finishMaxDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 30),
                                ),
                                builder: (context, child) {
                                  return child!;
                                },
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                              ).then((date) => {
                                    if (date != null)
                                      {
                                        showTimePicker(
                                                context: context,
                                                builder: (context, child) {
                                                  return MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              alwaysUse24HourFormat:
                                                                  true),
                                                      child: child!);
                                                },
                                                initialEntryMode:
                                                    TimePickerEntryMode
                                                        .inputOnly,
                                                initialTime: const TimeOfDay(
                                                    hour: 18, minute: 0))
                                            .then((time) => {
                                                  if (time != null)
                                                    {
                                                      setDateInput(
                                                          date.copyWith(
                                                              hour: time.hour,
                                                              minute:
                                                                  time.minute))
                                                    }
                                                })
                                      }
                                  });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ready at',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    children: [
                      IngredientWidget(
                          title: 'Total flour (g)', value: totalFlour),
                      IngredientWidget(
                          title: 'Total water (g)', value: totalWater),
                      IngredientWidget(
                          title: 'Total salt (g)', value: totalSalt),
                      const IngredientWidget(
                          title: 'Instant Yeast (g)', value: 6),
                      const IngredientWidget(title: 'Honey (g)', value: 6),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  children: <TextSpan>[
                    const TextSpan(
                        text: '\u2022 ',
                        style: TextStyle(color: Colors.red, fontSize: 14)),
                    TextSpan(
                        text:
                            'Start poolish between ${_startDate == null ? "_" : DateFormat("EEEE HH:mm").format(_startDate!)} and ${_startMaxDate == null ? "_" : DateFormat("EEEE HH:mm").format(_startMaxDate!)}'),
                  ],
                ),
              ),
              const SizedBox(
                height: 7.5,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  children: <TextSpan>[
                    const TextSpan(
                        text: '\u2022 ',
                        style: TextStyle(color: Colors.red, fontSize: 14)),
                    TextSpan(
                        text:
                            'Start dough between ${DateFormat("EEEE HH:mm").format(_finishMaxDate!.subtract(const Duration(hours: 3)))} and ${DateFormat("EEEE HH:mm").format(_finishMaxDate!.subtract(const Duration(hours: 2)))}'),
                  ],
                ),
              ),
              const SizedBox(
                height: 7.5,
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: const Text('Start'),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            LocalStorageService.setDoughConfig(DoughConfig(
                    totalFlour, totalWater, totalSalt, _finishMaxDate!))
                .then(
              (value) {
                nextPage(context);
              },
            );
          }
        },
      ),
    );
  }

  setValues(String amount) {
    setState(() {
      totalFlour = amount == "" ? 0 : (int.parse(amount) * 147.1).round();
      totalWater = amount == "" ? 0 : (int.parse(amount) * 103).round();
      totalSalt = amount == "" ? 0 : (int.parse(amount) * 4.4).round();
    });
  }

  void setDateInput(DateTime endDate) {
    setState(() {
      _finishMaxDate = endDate;
      _startDate = endDate.subtract(const Duration(hours: 28));
      _startMaxDate = endDate.subtract(const Duration(hours: 20));
      _dateInputController.text = DateFormat("EEEE HH:mm").format(endDate);
    });
  }

  void nextPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            PoolishPage(startDate: _startDate!, maxStartDate: _startMaxDate!),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
