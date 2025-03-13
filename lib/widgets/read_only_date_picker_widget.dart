import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class ReadOnlyDatePickerWidget extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;

  const ReadOnlyDatePickerWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon = Icons.calendar_today, // Default calendar icon
  });

  @override
  ConsumerState<ReadOnlyDatePickerWidget> createState() =>
      _ReadOnlyDatePickerWidgetState();
}

class _ReadOnlyDatePickerWidgetState
    extends ConsumerState<ReadOnlyDatePickerWidget> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        ref
            .read(dialogSelectionProvider.notifier)
            .updateSelection(widget.labelText, _dateController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      //controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 12),
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 13),
        suffixIcon: IconButton(
          icon: Icon(widget.icon, size: 17),
          onPressed: () => _selectDate(context),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}
