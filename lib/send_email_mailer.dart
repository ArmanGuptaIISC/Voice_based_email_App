// import 'dart:io';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';

// main() async {
//   String username = 'pankaj.ias543@gmail.com';
//   String password = '';

//   final smtpServer = gmail(username, password);
  
//   // Create our message.
//   final message = new Message()
//     ..from = new Address(username, 'Your name')
//     ..recipients.add('destination@example.com')
//     ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//     ..bccRecipients.add(new Address('bccAddress@example.com'))
//     ..subject = 'Test Dart Mailer library :: 😀 :: ${new DateTime.now()}'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//     ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
  
//   final sendReports = await send(message, smtpServer);
  
//   // DONE
  
  
//   // Let's send another message using a slightly different syntax:
//   //
//   // Addresses without a name part can be set directly.
//   // For instance `..recipients.add('destination@example.com')`
//   // If you want to display a name part you have to create an
//   // Address object: `new Address('destination@example.com', 'Display name part')`
//   // Creating and adding an Address object without a name part
//   // `new Address('destination@example.com')` is equivalent to
//   // adding the mail address as `String`.
//   final equivalentMessage = new Message()
//       ..from = new Address(username, 'Your name')
//       ..recipients.add(new Address('destination@example.com'))
//       ..ccRecipients.addAll([new Address('destCc1@example.com'), 'destCc2@example.com'])
//       ..bccRecipients.add('bccAddress@example.com')
//       ..subject = 'Test Dart Mailer library :: 😀 :: ${new DateTime.now()}'
//       ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//       ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
    
//   final sendReports2 = await send(equivalentMessage, smtpServer);
// }