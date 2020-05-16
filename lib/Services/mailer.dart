import 'dart:convert';
import 'package:apli/Shared/constants.dart';
import 'package:http/http.dart' as http;

class MailerService {
  String to_email, subject, body;
  MailerService({this.to_email, this.subject, this.body});

  Future send() async {
    int result;
    try {
      await http
          .post(send_mail,
              body: json.decode('{'
                  '"secret": "$send_mailSecret",'
                  '"to_email": "$to_email",'
                  '"subject": "$subject",'
                  '"body": "$body"'
                  '}'))
          .then((response) {
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          if (true) {
            if (decodedData["success"])
              result = 1;
            else
              result = 0;
          } else
            result = -2;
        } else {
          result = -2;
        }
      });
      return result ?? -2;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}

//main() async {
//  String username = 'username@gmail.com';
//  String password = 'password';
//
//  final smtpServer = gmail(username, password);
//  // Use the SmtpServer class to configure an SMTP server:
//  // final smtpServer = SmtpServer('smtp.domain.com');
//  // See the named arguments of SmtpServer for further configuration
//  // options.
//
//  // Create our message.
//  final message = Message()
//    ..from = Address(username, 'Your name')
//    ..recipients.add('destination@example.com')
//    ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//    ..bccRecipients.add(Address('bccAddress@example.com'))
//    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
//    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
//
//  try {
//    final sendReport = await send(message, smtpServer);
//    print('Message sent: ' + sendReport.toString());
//  } on MailerException catch (e) {
//    print('Message not sent.');
//    for (var p in e.problems) {
//      print('Problem: ${p.code}: ${p.msg}');
//    }
//  }
//  // DONE
//
//
//  // Let's send another message using a slightly different syntax:
//  //
//  // Addresses without a name part can be set directly.
//  // For instance `..recipients.add('destination@example.com')`
//  // If you want to display a name part you have to create an
//  // Address object: `new Address('destination@example.com', 'Display name part')`
//  // Creating and adding an Address object without a name part
//  // `new Address('destination@example.com')` is equivalent to
//  // adding the mail address as `String`.
//  final equivalentMessage = Message()
//    ..from = Address(username, 'Your name')
//    ..recipients.add(Address('destination@example.com'))
//    ..ccRecipients.addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
//    ..bccRecipients.add('bccAddress@example.com')
//    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
//    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
//
//  final sendReport2 = await send(equivalentMessage, smtpServer);
//
//  // Sending multiple messages with the same connection
//  //
//  // Create a smtp client that will persist the connection
//  var connection = PersistentConnection(smtpServer);
//
//  // Send the first message
//  await connection.send(message);
//
//  // send the equivalent message
//  await connection.send(equivalentMessage);
//
//  // close the connection
//  await connection.close();
//
//}
