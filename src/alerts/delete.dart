import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/src/alerts/nointernet.dart';
import 'package:marketplace/src/utils/utils.dart';

class DeleteAlert extends StatefulWidget {
  final DocumentSnapshot document;
  DeleteAlert(this.document);
  @override
  State<StatefulWidget> createState() {
    return DeleteAlertState();
  }
}

class DeleteAlertState extends State<DeleteAlert> {
  bool hasInternetAccess = false;

  Future<void> _checkInternetAccess() async {
    var result = await Utils.hasAccessToInternet();
    setState(() {
      hasInternetAccess = result;
    });
  }

  @override
  void initState() {
    _checkInternetAccess();
    super.initState();
  }

  List<String> _imageUrls() {
    String urls = widget.document['imageUrls'];
    var result = urls.split('#');
    result.removeLast();
    return result;
  }

  void removeImages() {
    _imageUrls().forEach((url) => FirebaseStorage.instance
        .getReferenceFromUrl(url)
        .then((ref) => ref.delete()));
  }

  void removeReservations() {
    Firestore.instance
        .collection('reservations')
        .where('product_id', isEqualTo: widget.document.documentID)
        .getDocuments()
        .then((v) => v.documents.forEach((w) => w.reference.delete()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: hasInternetAccess
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Czy na pewno chcesz \nusunąć ten produkt?',
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    icon: Icon(Icons.delete),
                    label: Text(
                      'Usuń',
                      textScaleFactor: 1.2,
                    ),
                    onPressed: () {
                      removeReservations();
                      removeImages();
                      widget.document.reference.delete();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            : NoInternet(_checkInternetAccess));
  }
}
