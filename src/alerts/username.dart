import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/user.dart';
import 'package:marketplace/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsernameAlert extends StatefulWidget {
  final VoidCallback onSuccess;

  UsernameAlert({@required this.onSuccess});

  @override
  State<StatefulWidget> createState() {
    return UsernameAlertState();
  }
}

class UsernameAlertState extends State<UsernameAlert> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool userExists = false;
  bool hasInternet = false;

  _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await Firestore.instance
        .collection('usernames')
        .document()
        .setData({'name': username});
  }

  Future<bool> _usernameExists(String username) async {
    QuerySnapshot result = await Firestore.instance
        .collection('usernames')
        .where('name', isEqualTo: username)
        .limit(1)
        .getDocuments();
    return result.documents.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 0, right: 20, left: 20),
        content: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Aby kontynuować utwórz swoją nazwę użytkownika:',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nazwa użytkownika'),
                  validator: (value) {
                    if (value.isEmpty) return 'Pole nie może być puste';
                    if (value.length > 20) return 'Maksymalnie 20 znaków';
                    if (!hasInternet) return 'Brak połączenia z internetem';
                    if (userExists) return 'Taka nazwa już istnieje';
                    return null;
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 25),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      icon: Icon(Icons.done),
                      label: Text('Gotowe',
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () async {
                        hasInternet = await Utils.hasAccessToInternet();
                        userExists =
                            await _usernameExists(_usernameController.text);
                        if (_formKey.currentState.validate()) {
                          _saveUsername(_usernameController.text);
                          LocalUserInfo.username = _usernameController.text;
                          Navigator.pop(context);
                          widget.onSuccess();
                        }
                      },
                    ))
              ])),
        ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
