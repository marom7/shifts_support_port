import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/models/employee.dart';
import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/controllers/employee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for WhatsApp icon

Widget buildShiftCard(String title, String hd, String it,
    void Function(String) onchangedHd, void Function(String) onchangedIt) {
  final EmployeeController controller = Get.put(EmployeeController());
 
  final List<Employee> techs = controller.getEmployeesByDuty(['טכנאי', 'מפעיל מחשב']);
  final List<Employee> managers = controller.getEmployeesByDuty(['מנהל רשת', 'סייבר']);
      
  if (controller.employees.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

   Future<void> sendWhatsApp(String phone, String message) async {
    String waPhone = phone.replaceAll('-', '').replaceFirst('0', '972');
    String uri ="https://wa.me/$waPhone?text=${Uri.encodeComponent(message)}";//'https://wa.me/${phone.replaceAll('-', '')}
    final Uri whatsappUri = Uri.parse(uri);
    //..if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    //} else {
    //  Get.snackbar('Error', 'Could not launch WhatsApp');
  }
  

  Future<void> makeCall(String phone) async {
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      Get.snackbar('Error', 'Could not make the call');
    }
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.all(8),
    color: title == 'משמרת בוקר'
        ? const Color.fromARGB(255, 79, 198, 182)
        : const Color.fromARGB(255, 41, 158, 212),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50, // Reduce the height of the dropdown
                  child: buildDropdown(hd.obs, techs.map((e) => e.name).toList(), onchangedHd, label: "טכנאי"),
                ),
              ),
              const SizedBox(width: 2),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => sendWhatsApp(techs.firstWhere((e) => e.name == hd).phone, "יש בעיה"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      minimumSize: Size.zero, // Minimum size
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: const Icon(FontAwesomeIcons.whatsapp), // WhatsApp icon
                  ),
                  const SizedBox(width: 2),
                  ElevatedButton(
                    onPressed: () => makeCall(techs.firstWhere((e) => e.name == hd).phone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size.zero, // Minimum size
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: const Icon(Icons.phone), // Phone icon
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50, // Reduce the height of the dropdown
                  child: buildDropdown(it.obs, managers.map((e) => e.name).toList(), onchangedIt, label: "מנהל רשת"),
                ),
              ),
              const SizedBox(width: 2),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => sendWhatsApp(managers.firstWhere((e) => e.name == it).phone, "יש בעיה"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize:  Size.zero, // Minimum size
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: const Icon(FontAwesomeIcons.whatsapp), // WhatsApp icon
                  ),
                  const SizedBox(width: 2),
                  ElevatedButton(
                    onPressed: () => makeCall(managers.firstWhere((e) => e.name == it).phone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize:   Size.zero, // Minimum size
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: const Icon(Icons.phone), // Phone icon
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

