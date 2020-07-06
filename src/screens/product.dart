import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/alerts/reserve.dart';
import 'package:marketplace/src/utils/contact_button.dart';
import 'package:marketplace/src/utils/fab_edit.dart';
import 'package:marketplace/src/utils/image_card.dart';
import 'package:marketplace/src/utils/location_button.dart';
import 'package:marketplace/src/utils/user.dart';

class ProductScreen extends StatelessWidget {
  final DocumentSnapshot document;
  ProductScreen(this.document);
  final double textScale = 1.2;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  List<String> _imageUrls() {
    String urls = document['imageUrls'];
    var result = urls.split('#');
    result.removeAt(0);
    result.removeLast();
    return result;
  }

  bool _isOwner() {
    return document['username'] == LocalUserInfo.username;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
            floatingActionButton: _isOwner()
                ? FabEditMenu(document)
                : Container(
                    width: 0,
                    height: 0,
                  ),
            appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text(document['name']),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )),
            body: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _imageUrls().map((url) {
                            return ImageCard(url);
                          }).toList(),
                        ))),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    document['description'],
                    textScaleFactor: textScale,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Miejsce odbioru: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          document['location'],
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                        LocationButton(document['location']),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Numer kontaktowy: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          document['contact'],
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                        ContactButton(document['contact']),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Cena: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          document['price'].toStringAsFixed(2),
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              ' zł/kg',
                              textScaleFactor: textScale,
                            )),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Ilość: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          document['quantity'].toStringAsFixed(2),
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              ' kg',
                              textScaleFactor: textScale,
                            )),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Wystawiający: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          document['username'],
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Ostatnia aktualizacja: ',
                              textScaleFactor: textScale,
                            )),
                        Flexible(
                            child: Container(
                                child: Text(
                          dateFormat.format(document['date'].toDate()),
                          textScaleFactor: textScale,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    )),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                  child: Container(
                      width: 180,
                      child: FittedBox(
                          child: FloatingActionButton.extended(
                        icon: Icon(Icons.playlist_add_check),
                        backgroundColor: _isOwner()
                            ? Colors.grey
                            : Theme.of(context).accentColor,
                        label: Text('Zarezerwuj',
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        onPressed: _isOwner()
                            ? null
                            : () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ReserveAlert(document)),
                      ))),
                )
              ],
            ))));
  }
}
