import '../shared/Recipient.dart';
import '../shared/DisturbanceType.dart';
import '../services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EmailSender extends StatefulWidget {
  const EmailSender(this._database, {Key key}): super(key: key);

  final DatabaseService _database;

  @override
  _EmailSenderState createState() => _EmailSenderState(_database);
}

class _EmailSenderState extends State<EmailSender> {
  _EmailSenderState(this._database);

  final _now = DateTime.now();
  final DatabaseService _database;

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

  List<dynamic> _selectedRecipients = [];

  static List<DisturbanceType> _disturbanceTypes = [
    DisturbanceType(id: 1, name: 'Mittagsruhe (13:00-15:00)'),
    DisturbanceType(id: 2, name: 'Nachtruhe (22:00-07:00)'),
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
    final utcNow = DateTime(_now.year, _now.month, _now.day, _now.hour, _now.minute, _now.second);

    try {
      await _database.logZipDateTime(_zipController.text, utcNow.toUtc());

      await launch(
          Uri(
              scheme: 'mailto',
              path: _selectedRecipients.join(','),
              queryParameters: {
                'subject': _subjectController.text,
                'body': 'Störung der '+_selectedDisturbanceType.name+"\n\n"+
                    'PLZ: '+_zipController.text+"\n"+
                    'Datum lokal: '+_now.toString()+"\n"+
                    'Datum UTC: '+utcNow.toUtc().toIso8601String(),
              }
          ).toString().replaceAll('+', '%20')
      );

      platformResponse = 'E-Mail erstellt';
    } catch (error) {
      platformResponse = error.toString();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  void initState() {
    _selectedRecipients = _recipients;
    _selectedRecipients = _selectedRecipients.map((recipient) => recipient as dynamic)
        .toList();
    _subjectController.text += _now.toString();

    if (_now.weekday == DateTime.sunday) {
      _selectedDisturbanceType = _disturbanceTypes[2];
    } else if (_now.hour >= 13 && _now.hour <= 15) {
      _selectedDisturbanceType = _disturbanceTypes[0];
    } else if (_now.hour >= 22 || _now.hour <= 7) {
      _selectedDisturbanceType = _disturbanceTypes[1];
    } else {
      _selectedDisturbanceType = _disturbanceTypes[2];
    }

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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 3 * 2) - 15,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dialogBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 0,
                          bottom: 0,
                        ),
                        child: DropdownButtonFormField<DisturbanceType>(
                          iconSize: 0,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 16,
                            ),
                            labelText: 'Störung',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: Icon(
                              Icons.do_disturb_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          isExpanded: true,
                          value: _selectedDisturbanceType,
                          items: _disturbanceTypeList,
                          onChanged: (DisturbanceType newValue) {
                            setState(() {
                                _selectedDisturbanceType = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: (MediaQuery.of(context).size.width / 3) - 15,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dialogBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 10,
                        ),
                        child: TextField(
                          controller: _zipController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.gps_fixed,
                              color: Theme.of(context).primaryColor,
                            ),
                            border: InputBorder.none,
                            labelText: 'PLZ',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).popupMenuTheme.color,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectDialogField(
                      barrierColor: Theme.of(context).hintColor,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: Text('Empfänger'),
                      title: Text('Empfänger'),
                      items: _recipientList,
                      buttonIcon: Icon(
                        Icons.mail,
                        color: Theme.of(context).primaryColor,
                      ),
                      onConfirm: (values) {
                        _selectedRecipients = values;
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        //icon: Icon(Icons.highlight_off),
                        onTap: (value) {
                          setState(() {
                            _selectedRecipients.remove(value);
                          });
                        },
                      ),
                      initialValue: _selectedRecipients
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
