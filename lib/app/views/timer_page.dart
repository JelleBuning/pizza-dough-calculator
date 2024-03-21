import 'dart:async';
import 'package:dough_calculator/app/services/localstorage_service.dart';
import 'package:dough_calculator/app/views/home_page.dart';
import 'package:dough_calculator/app/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerPage extends StatefulWidget {
  final String title;
  final String subTitle;
  final String doneText;
  final String btnDoneText;
  final DateTime notifyAt;
  final DateTime? maxDateTime;
  final Duration duration;
  final Function(DateTime pressedAt) onPressedCallback;

  const TimerPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.notifyAt,
    required this.duration,
    required this.onPressedCallback,
    this.maxDateTime,
    this.doneText = "Done",
    this.btnDoneText = "Next",
  });
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  double _lastPercentage = 0;

  late int _start;
  late double _percentage;

  @override
  initState() {
    super.initState();
    _start = widget.notifyAt.difference(DateTime.now()).inSeconds;
    _percentage = _start / widget.duration.inSeconds;
    _lastPercentage = _percentage;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double progressSize = 300;

    return PageTemplate(
        appbar: AppBar(
          title: Text(widget.title),
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.subTitle,
                            style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(
                          height: 2.5,
                        ),
                        widget.maxDateTime != null
                            ? RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${DateFormat("EEEE").format(widget.notifyAt)}, between '),
                                    TextSpan(
                                        text: DateFormat("HH:mm")
                                            .format(widget.notifyAt),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                        text: DateFormat("HH:mm")
                                            .format(widget.maxDateTime!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'Until ${DateFormat("EEEE").format(widget.notifyAt)}'),
                                    TextSpan(
                                        text: DateFormat(" HH:mm")
                                            .format(widget.notifyAt),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: SizedBox(
                height: progressSize,
                width: progressSize,
                child: Stack(
                  children: [
                    SizedBox(
                        height: progressSize,
                        width: progressSize,
                        child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: _lastPercentage, end: _percentage),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, _) {
                              return CircularProgressIndicator(
                                backgroundColor: Theme.of(context).cardColor,
                                value: value,
                                strokeWidth: 10,
                                strokeCap: StrokeCap.round,
                              );
                            })),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox.shrink(),
                          Text(
                            _start <= 0
                                ? widget.doneText
                                : '${Duration(seconds: _start).inHours.toString().padLeft(2, '0')}:${(Duration(seconds: _start).inMinutes - Duration(seconds: _start).inHours * 60).toString().padLeft(2, '0')}:${(Duration(seconds: _start).inSeconds - Duration(seconds: _start).inMinutes * 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                                letterSpacing: 3,
                                color: Colors.grey[300],
                                fontSize: 38),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
          ],
        ),
        floatingActionButton: _start > 0
            ? FloatingActionButton.extended(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.white,
                splashColor: Colors.transparent,
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
                  child: const Text('Hold on...'),
                ),
                onPressed: () => {},
              )
            : FloatingActionButton.extended(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
                  child: Text(widget.btnDoneText),
                ),
                onPressed: () => widget.onPressedCallback(DateTime.now()),
              ));
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          setState(() {
            timer.cancel();
            _percentage = 1;
          });
        } else {
          if (mounted) {
            setState(() {
              _start = widget.notifyAt.difference(DateTime.now()).inSeconds;
              _percentage = _start / widget.duration.inSeconds;
              _lastPercentage = _percentage;
              _percentage = _start / widget.duration.inSeconds;
              _start--;
            });
          }
        }
      },
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
            Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
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
