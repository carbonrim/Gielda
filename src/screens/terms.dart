import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Terms extends StatelessWidget {
  final String terms =
      "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Polityka prywatności'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  terms,
                  textScaleFactor: 1.2,
                )),
            Padding(
                padding: EdgeInsets.all(15),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  icon: Icon(Icons.keyboard_backspace),
                  label: Text('Wróć'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))
          ],
        ))));
  }
}
