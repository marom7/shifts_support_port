import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildDropdown(
  RxString selected,
  List<String> items,
  void Function(String) onChanged, {
  String? label, // הוסף פרמטר לתווית
}) {
  return Obx(() {
    // אם הערך הנבחר לא נמצא בפריטים – מציגים null (ללא בחירה)
    final String? current =
        (selected.value.isNotEmpty && items.contains(selected.value))
            ? selected.value
            : null;

    return DropdownButtonFormField2<String>(
      value: current,
      isExpanded: true,
      items: items
          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
          .toList(),
      onChanged: (val) {
        final v = val ?? '';
        selected.value = v;   // מעדכן את ה-Rx
        onChanged(v);         // מודיע להורה (שמירה, לוגיקה נוספת וכו')
      },
      decoration: InputDecoration(
        labelText: label,                 // עובר מההורה
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      dropdownStyleData: const DropdownStyleData(
        decoration: BoxDecoration(
          color: Color(0xFFE0F7FA),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  });
}
