import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoInternet extends StatelessWidget {
  final void Function() onPressed;

  NoInternet(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Brak dostępu do internetu'),
        Container(
          height: 20,
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: Icon(Icons.refresh),
          label: Text('Odśwież'),
          onPressed: onPressed,
        )
      ],
    );
  }
}
