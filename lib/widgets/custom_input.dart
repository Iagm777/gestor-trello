import 'package:flutter/material.dart';

/// Widget de Input Personalizado
class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInput({
    Key? key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
