import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButton extends StatelessWidget {
  final String number;
  ContactButton(this.number);

  _callNumber() async {
    String url = 'tel:' + number;
    if (await canLaunch(url)) launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.phone),
      color: Theme.of(context).accentColor,
      onPressed: _callNumber,
    );
  }
}
