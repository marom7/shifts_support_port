import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildDropdown(
    RxString selected, List<String> items, void Function(String) onChanged) {
  return DropdownButtonFormField2<String>(
    value: selected.value.isEmpty ? null : selected.value,
    items: items
        .map((name) => DropdownMenuItem(value: name, child: Text(name)))
        .toList(),
    onChanged: (val) => onChanged(val ?? ''),
    decoration: InputDecoration(
      labelText: items.contains('מרום מילנר') ? 'טכנאי' : 'מנהל רשת',
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
}
  
  /*
  return DropdownButtonFormField<String>(
      value: selected.value.isEmpty ? null : selected.value,
      dropdownColor: Colors.white,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      items: items
          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
          .toList(),
      onChanged: (val) => selected.value = val ?? "",
    );
    */