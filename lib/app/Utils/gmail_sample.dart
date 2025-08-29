//import 'package:enough_mail/enough_mail.dart';

// ignore_for_file: avoid_print

import 'package:enough_mail/enough_mail.dart';

main() async {
   readEmails();
} 

Future<void> readEmails() async {
  final client = ImapClient(isLogEnabled: true);
  try {
    await client.connectToServer('imap.gmail.com', 993, isSecure: true);
    await client.login('marom7@gmail.com', 'zjnnglogkmmuqgcu');
    await client.selectInbox();
    final fetchResponse = await client.fetchMessages(
      MessageSequence.fromRange(1, 10), // מספר ההודעות
      'BODY.PEEK[]', 
    );
    for (final message in fetchResponse.messages) {
      print('Subject: ${message.decodeSubject()}');
      print('From: ${message.from}');
      print('Text: ${message.decodeTextPlainPart()}');
    }
    await client.logout();
  } catch (e) {
    print('Error: $e');
  }
}

void readEmails2() async {
  final client = ImapClient(isLogEnabled: true);

  await client.connectToServer('imap.google.com', 993, isSecure: true);
  await client.login('marom7@gmail.com', 'mg280774');
  await client.selectInbox();

  // קריאת הודעות 
  final messages = await client.fetchRecentMessages(
    messageCount: 10,
    criteria: 'ALL',
    // אפשר לשחק עם הקריטריון: 'UNSEEN', 'SEEN' וכו'
  );

  for (var msg in messages.messages) {
    print('נושא: ${msg.headers}');
    print('מאת: ${msg.headers!.length.toString()}');
    //print('תוכן: ${msg.bodyText}');
  }

  await client.logout();
}
