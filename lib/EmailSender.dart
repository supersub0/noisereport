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
    DisturbanceType(id: 1, name: 'Störung Mittagsruhe (13:00-15:00)'),
    DisturbanceType(id: 2, name: 'Störung Nachtruhe (20:00-07:00)'),
    DisturbanceType(id: 3, name: 'Störung Feiertagsruhe (ganztägig)'),
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
        path: _selectedRecipients.toString(),
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
  void initState() {
    var utcNow = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    _selectedRecipients = _recipients;
    _selectedDisturbanceType = _disturbanceTypes[1];
    _subjectController.text += utcNow.toString();
    _bodyController.text += utcNow.toString()+"\n";
    _bodyController.text += 'Datum UTC: '+utcNow.toUtc().toIso8601String();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('kukukonline'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
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
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
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
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
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
                      /*TextField(
                        controller: _zipController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.do_disturb_rounded),
                          border: InputBorder.none,
                          labelText: 'Störungsart',
                        ),
                      ),*/
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    /*
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
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: MultiSelectBottomSheetField(
                searchable: true,
                title: Text('Empfänger'),
                buttonText: Text('Empfänger'),
                listType: MultiSelectListType.CHIP,
                chipDisplay: MultiSelectChipDisplay(
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
                initialValue: _recipients,
              ),
            ),
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
     */
  }
}
