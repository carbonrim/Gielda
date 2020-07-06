import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/src/alerts/nointernet.dart';
import 'package:marketplace/src/utils/utils.dart';

class ReservationsAlert extends StatefulWidget {
  final DocumentSnapshot document;
  ReservationsAlert(this.document);
  @override
  State<StatefulWidget> createState() {
    return ReservationsAlertState();
  }
}

class ReservationsAlertState extends State<ReservationsAlert> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
        content: hasInternetAccess
            ? Container(
                height: 200,
                width: double.maxFinite,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('reservations')
                      .where('product_id',
                          isEqualTo: widget.document.documentID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.data.documents.length == 0)
                      return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                              child: Text('Brak rezerwacji dla tego produktu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 15,
                                  ))));
                    return Scrollbar(
                        child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, int index) {
                        var product = snapshot.data.documents[index];
                        return Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Center(
                                      child: Text(
                                product['user'] +
                                    ':  ' +
                                    product['quantity'].toStringAsFixed(2) +
                                    ' [kg]',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))),
                              SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: IconButton(
                                    padding: new EdgeInsets.all(0.0),
                                    icon: Icon(Icons.delete_sweep),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      product.reference.delete();
                                    },
                                  ))
                            ],
                          ),
                          Divider()
                        ]);
                      },
                    ));
                  },
                ))
            : NoInternet(_checkInternetAccess));
  }
}
