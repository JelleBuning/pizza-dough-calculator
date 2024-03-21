import 'package:flutter/material.dart';

class IngredientWidget extends StatelessWidget {
  final String title;
  final int? value;
  const IngredientWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: SizedBox(
          width: isMobile ? double.infinity : 267,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 2.5,
              ),
              Text(value == null ? "___" : '$value gr',
                  style: TextStyle(color: Colors.grey[300], fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}