import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final AppBar appbar;
  final Widget content;
  final FloatingActionButton? floatingActionButton;
  const PageTemplate(
      {super.key,
      required this.content,
      required this.appbar,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Scaffold(
            appBar: appbar,
            body: Padding(padding: const EdgeInsets.all(25), child: content),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    );
  }
}
