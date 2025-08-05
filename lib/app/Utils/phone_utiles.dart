import 'package:get/get.dart';
//import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

//final Telephony telephony = Telephony.instance;

/*void directCall(String number) async {
  // בקש הרשאה בזמן ריצה
  final permissionGranted = await telephony.requestPhonePermissions;
  if (permissionGranted != null && permissionGranted) {
    telephony.dialPhoneNumber(number);
  }
}
*/

Future<void> sendWhatsApp(String phone, String message) async {
  try {
    String waPhone = phone.replaceAll('-', '').replaceFirst('0', '972', 0);
    //String defaultMessage = "שלום ${employee.name}, יש בעיה במשמרת";
    String uri = "https://wa.me/$waPhone?text=${Uri.encodeComponent(message)}";
    
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      Get.snackbar('שגיאה', 'לא ניתן לפתוח את WhatsApp');
    }
  } catch (e) {
    Get.snackbar('שגיאה', 'בעיה בשליחת הודעה: ${e.toString()}');
  }
}

Future<void> makeCall(String phone) async {
  try {
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      Get.snackbar('שגיאה', 'לא ניתן לבצע שיחה');
    }
  } catch (e) {
    Get.snackbar('שגיאה', 'בעיה בחיוג: ${e.toString()}');
  }
}