import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EmailSender extends StatefulWidget {
  const EmailSender({Key key}): super(key: key);

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class Recipient {
  final int id;
  final String name;

  Recipient({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return this.name;
  }
}

class DisturbanceType {
  final int id;
  final String name;

  DisturbanceType({
    this.id,
    this.name,
  });
}

class _EmailSenderState extends State<EmailSender> {
  final now = DateTime.now();

  static List<Recipient> _recipients = [
    Recipient(id: 1, name: 'poststelle@bmvg.bund.de'),
    Recipient(id: 2, name: 'FLIZ@bundeswehr.org'),
    Recipient(id: 3, name: 'helga.i.moser.ln@mail.mil'),
    Recipient(id: 4, name: 'hubschrauberlaerm@ansbach.de'),
    Recipient(id: 5, name: 'fluglaerm@landratsamt-ansbach.de'),
  ];

  final _recipientList = _recipients
      .map((recipient) => MultiSelectItem<Recipient>(recipient, recipient.name))
      .toList();

  List<Recipient> _selectedRecipients = [];

  static List<DisturbanceType> _disturbanceTypes = [
    DisturbanceType(id: 1, name: 'Mittagsruhe (13:00-15:00)'),
    DisturbanceType(id: 2, name: 'Nachtruhe (20:00-07:00)'),
    DisturbanceType(id: 3, name: 'Feiertagsruhe (ganztägig)'),
  ];

  final _disturbanceTypeList = _disturbanceTypes
      .map<DropdownMenuItem<DisturbanceType>>((DisturbanceType disturbanceType) {
        return DropdownMenuItem<DisturbanceType>(
          value: disturbanceType,
          child: Text(disturbanceType.name),
        );
      })
      .toList();

  DisturbanceType _selectedDisturbanceType;

  final _subjectController = TextEditingController(
    text: 'Lärmbelästigung (Hubschrauber) ',
  );

  final _zipController = TextEditingController(
    text: '91522',
  );

  Future<void> _send() async {
    String platformResponse;
    final utcNow = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: _selectedRecipients.join(','),
        queryParameters: {
          'subject': _subjectController.text,
          'body': 'Störung der '+_selectedDisturbanceType.name+"\n\n"+
            'PLZ: '+_zipController.text+"\n"+
            'Datum lokal: '+now.toString()+"\n"+
            'Datum UTC: '+utcNow.toUtc().toIso8601String(),
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
  void initState() {
    _selectedRecipients = _recipients;
    _selectedDisturbanceType = _disturbanceTypes[1];
    _subjectController.text += now.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kukukonline'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _send,
        child: const Icon(Icons.send),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MultiSelectDialogField(
                barrierColor: new Color.fromRGBO(255, 0, 0, 0.1),
                searchable: true,
                title: Text('Empfänger'),
                buttonText: Text('Empfänger'),
                listType: MultiSelectListType.CHIP,
                chipDisplay: MultiSelectChipDisplay(
                  icon: Icon(Icons.highlight_off),
                  onTap: (value) {
                    setState(() {
                      _selectedRecipients.remove(value);
                    });
                  },
                ),
                onSaved: (values) {
                  setState(() {
                    _selectedRecipients = values;
                  });
                },
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.mail,
                  color: Colors.red,
                ),
                items: _recipientList,
                initialValue: _selectedRecipients,
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  top: 0,
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Betreff',
                        suffixIcon: Icon(
                          Icons.subject,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  top: 0,
                ),
                child: TextField(
                  controller: _zipController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.gps_fixed,
                      color: Colors.red,
                    ),
                    border: InputBorder.none,
                    labelText: 'Postleitzahl',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                ),
                child: DropdownButtonFormField<DisturbanceType>(
                  decoration: InputDecoration.collapsed(hintText: ''),
                  isExpanded: true,
                  value: _selectedDisturbanceType,
                  icon: Icon(
                    Icons.do_disturb_rounded,
                    color: Colors.red,
                  ),
                  items: _disturbanceTypeList,
                  onChanged: (DisturbanceType newValue) {
                    setState(() {
                      _selectedDisturbanceType = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
