import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/alerts/delete.dart';
import 'package:marketplace/src/alerts/promote.dart';
import 'package:marketplace/src/alerts/reservations.dart';
import 'package:marketplace/src/alerts/update.dart';
import 'package:unicorndial/unicorndial.dart';

class FabEditMenu extends StatelessWidget {
  final DocumentSnapshot document;
  FabEditMenu(this.document);

  @override
  Widget build(BuildContext context) {
    var childButtons = [
      UnicornButton(
          hasLabel: true,
          labelText: "Promuj produkt",
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.orangeAccent,
            mini: true,
            child: Icon(Icons.trending_up),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => PromoteAlert(document)),
          )),
      UnicornButton(
          hasLabel: true,
          labelText: "Zobacz rezerwacje",
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.lightGreen,
            mini: true,
            child: Icon(Icons.format_list_bulleted),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => ReservationsAlert(document)),
          )),
      UnicornButton(
          hasLabel: true,
          labelText: "Aktualizuj ilość",
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.blueAccent,
            mini: true,
            child: Icon(Icons.refresh),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => UpdateAlert(document)),
          )),
      UnicornButton(
          hasLabel: true,
          labelText: "Usuń produkt",
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.redAccent,
            mini: true,
            child: Icon(Icons.delete),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => DeleteAlert(document)),
          ))
    ];

    return UnicornDialer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.3),
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.edit),
      childButtons: childButtons,
      animationDuration: 150,
      parentHeroTag: null,
    );
  }
}
