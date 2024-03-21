import 'package:dough_calculator/app/widgets/page_template.dart';
import 'package:flutter/material.dart';

class DoughPage extends StatefulWidget {
  const DoughPage({super.key});

  @override
  State<DoughPage> createState() => _DoughPageState();
}

class _DoughPageState extends State<DoughPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      appbar: AppBar(
        title: const Text("Create the dough"),
        leading: IconButton(
          onPressed: () => showAlertDialog(context), 
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
          splashRadius: 25,
        ),
      ),
      content: const Placeholder());
  }

  
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Stop timer"),
      content: const Text("Are you sure you want to leave this page?"),
      actions: [
        ElevatedButton(
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Ok"),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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