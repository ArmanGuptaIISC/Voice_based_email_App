import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';

// class FlutterEmailSender {
//   static const MethodChannel _channel =
//       const MethodChannel('flutter_email_sender');

//   static Future<void> send(Email mail) {
//     return _channel.invokeMethod('send', mail.toJson());
//   }
// }

class Email {
   String subject="new MAil";
   List<String> recipients;
   List<String> cc;
   List<String> bcc;
   String body="My body";
   String attachmentPath;
   GlobalKey<ScaffoldState> _scaffoldKey;
  Email( subject,body,recipients,attachmentPath,scaffoldKey)
  {
    this.subject = subject;
    this.recipients =recipients;
    this.body = body;
    this.attachmentPath=attachmentPath;
    _scaffoldKey=scaffoldKey;
    send_mail();
  }

  send_mail() {
    var options = new GmailSmtpOptions()
    ..username = 'armangupta0504@gmail.com'
    ..password = 'sagar1611'; 

    var emailTransport = new SmtpTransport(options);
  
  // Create our message.
   var envelope = new Envelope()
    ..from = "armangupta0504@gmail.com"
    ..recipients.add(recipients[0])
   // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
   // ..bccRecipients.add(new Address('bccAddress@example.com'))
    ..subject = subject
    ..text = "Hello there"
    ..html = "<p>$body</p>";
  
   emailTransport.send(envelope)
    .then((envelope){
      print('Email sent!');
       _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Email Sent!'),));
    })
    .catchError((e){
      print('Error occurred: $e');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Email is not sent.Check your internet connection'),));
      });
  }

  
}
