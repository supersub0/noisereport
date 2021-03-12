import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailSender extends StatefulWidget {
  const EmailSender({Key key}): super(key: key);

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  var now = DateTime.now();

  final _recipientController = TextEditingController(
    text: 'poststelle@bmvg.bund.de; '+
      'FLIZ@bundeswehr.org; '+
      'helga.i.moser.ln@mail.mil; '+
      'hubschrauberlaerm@ansbach.de; '+
      'fluglaerm@landratsamt-ansbach.de',
  );

  final _subjectController = TextEditingController(
    text: 'Lärmbelästigung (Hubschrauber) ',
  );

  final _bodyController = TextEditingController(
    text: 'Störung der:'+"\n"+
        '[  ] Mittagsruhe (13:00-15:00)'+"\n"+
        '[  ] Nachtruhe (20:00-07:00)'+"\n"+
        '[  ] Feiertagsruhe (ganztägig)'+"\n\n"+
        'PLZ: 91522'+"\n"+
        'Datum lokal: ',
  );

  Future<void> send() async {
    String platformResponse;

    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: _recipientController.text,
        queryParameters: {
          'subject': _subjectController.text,
          'body': _bodyController.text,
        }
    );

    try {
      await launch(_emailLaunchUri.toString().replaceAll('+', '%20'));
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var utcNow = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    _subjectController.text += utcNow.toString();
    _bodyController.text += utcNow.toString()+"\n";
    _bodyController.text += 'Datum UTC: '+utcNow.toUtc().toIso8601String();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kukukonline'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Empfänger',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Betreff',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      labelText: 'Nachricht', border: OutlineInputBorder()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
