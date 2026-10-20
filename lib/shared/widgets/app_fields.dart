import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint),
      );
}

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.label,
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  var _obscured = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: _obscured,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            tooltip: _obscured ? 'Mostrar senha' : 'Ocultar senha',
            onPressed: () => setState(() => _obscured = !_obscured),
            icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      );
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({required this.onChanged, super.key, this.hint = 'Buscar'});

  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
        ),
      );
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      );
}

class AppDateField extends StatelessWidget {
  const AppDateField({required this.label, required this.value, required this.onTap, super.key});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _ReadOnlyField(
        label: label,
        value: value,
        icon: Icons.calendar_today_outlined,
        onTap: onTap,
      );
}

class AppTimeField extends StatelessWidget {
  const AppTimeField({required this.label, required this.value, required this.onTap, super.key});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _ReadOnlyField(
        label: label,
        value: value,
        icon: Icons.access_time_outlined,
        onTap: onTap,
      );
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: InputDecoration(labelText: label, suffixIcon: Icon(icon)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text(value),
          ),
        ),
      );
}
