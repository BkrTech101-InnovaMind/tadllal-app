import 'package:flutter/material.dart';

class PagesBackButton extends StatefulWidget {
  const PagesBackButton({super.key});

  @override
  State<PagesBackButton> createState() => _PagesBackButtonState();
}

class _PagesBackButtonState extends State<PagesBackButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 30.0,
      minWidth: 50.0,
      color: const Color(0xFFF5F4F8),
      shape: const CircleBorder(),
      textColor: const Color(0xFF1F4C6B),
      padding: const EdgeInsets.all(16),
      onPressed: () => Navigator.pop(context),
      splashColor: const Color(0xFFF5F4F8),
      child: const Icon(Icons.arrow_back_ios_rounded, size: 18),
    );
  }
}
