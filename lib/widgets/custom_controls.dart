import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.onChanged,
    this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final ValueChanged<String?>? onChanged;
  final Widget? suffix;
  final bool Function(String?)? validator;

  OutlineInputBorder _borde(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    final text = controller.text;
    final valid = validator == null ? true : validator!(text);
    final colorScheme = Theme.of(context).colorScheme;
    final color = text.isEmpty ? Colors.grey : (valid ? colorScheme.primary : Theme.of(context).colorScheme.error);
    final fill = Colors.grey[100];

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: (v) => onChanged?.call(v),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: fill,
        border: _borde(color),
        enabledBorder: _borde(color),
        focusedBorder: _borde(color),
        suffixIcon: suffix,
      ),
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: loading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(label),
    );
  }
}
