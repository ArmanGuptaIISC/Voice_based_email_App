import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';

class Email {
   String subject="new MAil";
   List<String> recipients;
   List<String> cc;
   List<String> bcc;
   String body="My body";
   String attachmentPath;
   String senderEmail,password;
   GlobalKey<ScaffoldState> _scaffoldKey;
  Email(senderEmail,password,subject,body,recipients,attachmentPath,scaffoldKey)
  {
    this.senderEmail=senderEmail;
    this.password=password;
    this.subject = subject;
    this.recipients =recipients;
    this.body = body;
    this.attachmentPath=attachmentPath;
    _scaffoldKey=scaffoldKey;
    send_mail();
  }

  send_mail() {
    var options = new GmailSmtpOptions()
    ..username = senderEmail
    ..password = password; 

    var emailTransport = new SmtpTransport(options);
  
  // Create our message.
   var envelope = new Envelope()
    ..from = senderEmail
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
        content: Text('Email is not sent.Please check your email or check your internet connection'),));
      });
  }

  
}
