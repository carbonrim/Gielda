import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationButton extends StatelessWidget {
  final String address;
  LocationButton(this.address);

  _launchAddress() async {
    String url = 'https://www.google.com/maps/search/?api=1&query=' + address;
    if (await canLaunch(url)) launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.my_location),
      color: Theme.of(context).accentColor,
      onPressed: _launchAddress,
    );
  }
}
