//import 'package:enough_mail/enough_mail.dart';

// ignore_for_file: avoid_print

import 'package:enough_mail/enough_mail.dart';
import 'package:intl/intl.dart';

main() async {
   readEmails2();
} 

Future<void> readEmails() async {
  final client = ImapClient(isLogEnabled: true);
  try {
    await client.connectToServer('imap.gmail.com', 993, isSecure: true);
    await client.login('marom7@gmail.com', '');
    await client.selectInbox();
    final fetchResponse = await client.fetchMessages(
      MessageSequence.fromRange(10, 200), // מספר ההודעות
      'BODY.PEEK[]', 
    );
    for (final message in fetchResponse.messages) {
      //print('Subject: ${message.decodeSubject()}');
      //print('From: ${message.from}');@ashdodport.co.il
      //print('Text: ${message.decodeTextPlainPart()}');
      if(message.decodeSubject().toString().contains("DIGI")) {
        print('DATA: ${message.body}');
      }
    }
    await client.logout();
  } catch (e) {
    print('Error: $e');
  }
}

void readEmails2() async {
  final client = ImapClient(isLogEnabled: true);

  await client.connectToServer('imap.gmail.com', 993, isSecure: true);
  await client.login('marom7@gmail.com', 'zjnnglogkmmuqgcu');
  await client.selectInbox();
    // חישוב תאריך לפני 5 ימים
  final fiveDaysAgo = DateTime.now().subtract(const Duration(days: 5));
  final sinceDate = DateFormat('dd-MMM-yyyy').format(fiveDaysAgo); // פורמט IMAP נכון
    final search = await client.searchMessages(searchCriteria: 'SINCE $sinceDate FROM "app@ashdodport.co.il"');
    final mails5days = search.matchingSequence?.toList();
    final seq = MessageSequence.fromIds(mails5days!);
    // בקשה ל-ENVELOPE (כותרות)
    final envRes  = await client.fetchMessages(seq, 'ENVELOPE');
    // בקשה לגוף טקסט (PEEK = לא מסמן כנקרא)
    final bodyRes = await client.fetchMessages(seq, 'BODY.PEEK[TEXT]');
    
  for (var i = envRes.messages.length - 1; i >= 0; i--) {
    final env  = envRes.messages[i];
    final text = bodyRes.messages[i].decodeTextPlainPart();
    final subject = env.decodeSubject() ?? '(ללא נושא)';
    final from    = env.from?.toString() ?? '(ללא שולח)';
    final date    = env.decodeDate()?.toIso8601String() ?? '(ללא תאריך)';
     print('----------------------');
      print('MESSAGE NUMBER: ${i.toString()}');
      print('SUBJECT: $subject');
      print('מאת: $from');
      print('DATE: $date');
      print('DATA: $text');
  }
    await client.logout();
}

// אופציונלי: גם HTML אם צריך
    //final htmlRes = await client.fetchMessages(newest50, 'BODY.PEEK[HTML]');
    // שלב 3: שליפת ההודעות בפועל
    //final fetchResult = await client.fetchMessages(newest10, 'ENVELOPE BODY.PEEK[TEXT] BODY.PEEK[HEADER]');
    //final fetchResult = await client.fetchMessages(
   //   newest50,
   //   'ENVELOPE', // fetch envelope, body, and flags& BODY.PEEK[] & FLAGS
   // );
    //int i = 0;
    // שלב 4: הדפסה מהחדש לישן
    // הדפסה מהחדש לישן (אותו סדר UIDs)
    //final body    = text ?? (html?.replaceAll(RegExp(r'<[^>]+>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim() ?? '');
   // print('נושא: $subject');
  //  print('מאת:  $from');
   // print('תאריך: $date');
   // print('גוף:   ${text!.isEmpty ? "(אין תוכן)" : text}');
   // print('---------------------------');
   //if(subject.contains("digi")) {
   //     print('MESSAGE NUMBER: ${i.toString()}');
   //     print('SUBJECT: $subject');
   //     print('מאת: $from');
   //     print('DATE: $date');
   //     print('DATA: $text');
   //   }
   // שלב 1: חיפוש כל ההודעות
    //final searchResult = await client.searchMessages(searchCriteria:  'ALL');
    //final uids = searchResult.matchingSequence; // כאן באמת הרשימה של ה־UIDs
// שלב 2: לוקחים את 10 האחרונים (החדשים ביותר)
    //final newest100 = uids.length > 100 ? uids.subsequence(uids.length - 120) : uids;
   // if (uids!.isEmpty) {
    //  print('אין הודעות בתיבה');
    //  return;
   // }
