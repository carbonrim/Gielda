import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marketplace/src/alerts/nointernet.dart';
import 'package:marketplace/src/utils/user.dart';
import 'package:marketplace/src/utils/utils.dart';

class ReserveAlert extends StatefulWidget {
  final DocumentSnapshot document;
  ReserveAlert(this.document);
  @override
  State<StatefulWidget> createState() {
    return ReserveAlertState();
  }
}

class ReserveAlertState extends State<ReserveAlert> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool hasInternetAccess = false;
  var quantityCtrl = TextEditingController();
  num price = 0;

  Future<void> _checkInternetAccess() async {
    var result = await Utils.hasAccessToInternet();
    setState(() {
      hasInternetAccess = result;
    });
  }

  @override
  void initState() {
    _checkInternetAccess();
    quantityCtrl.addListener(updatePrice);
    super.initState();
  }

  replaceCommas() {
    if (quantityCtrl.text != null && quantityCtrl.text.contains(',')) {
      quantityCtrl.text = quantityCtrl.text.replaceAll(new RegExp(r','), '.');
      quantityCtrl.selection = new TextSelection.fromPosition(
          new TextPosition(offset: quantityCtrl.text.length));
    }
  }

  updatePrice() {
    replaceCommas();
    if (quantityCtrl.text != null &&
        num.tryParse(quantityCtrl.text.replaceAll(new RegExp(r','), '.')) !=
            null) {
      setState(() {
        price = widget.document['price'] *
            num.parse(quantityCtrl.text.replaceAll(new RegExp(r','), '.'));
      });
    } else {
      setState(() {
        price = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 0, right: 20, left: 20),
        content: hasInternetAccess
            ? FormBuilder(
                key: _fbKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Zarezerwuj produkt'),
                      FormBuilderTextField(
                        attribute: 'quantity',
                        controller: quantityCtrl,
                        decoration: InputDecoration(labelText: "Ilość (kg)"),
                        keyboardType: TextInputType.number,
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Pole nie może być puste'),
                          FormBuilderValidators.numeric(
                              errorText: 'Wprowadź liczbę'),
                          FormBuilderValidators.max(widget.document['quantity'],
                              errorText: 'Przekroczono maksymalną ilość'),
                          FormBuilderValidators.min(0.01,
                              errorText: 'Wprowadź poprawną ilość')
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Opacity(
                              opacity: 0.6,
                              child: Text(
                                'Cena: ',
                              )),
                          Flexible(
                              child: Container(
                                  child: Text(
                            price == 0 ? '' : price.toStringAsFixed(2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))),
                          Opacity(
                              opacity: 0.6,
                              child: Text(
                                ' zł',
                              )),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          child: FloatingActionButton.extended(
                              icon: Icon(Icons.done),
                              label: Text('Gotowe'),
                              onPressed: () {
                                _fbKey.currentState.save();
                                if (_fbKey.currentState.validate()) {
                                  widget.document.reference.updateData({
                                    'quantity': widget.document['quantity'] -
                                        num.parse(_fbKey
                                            .currentState.value['quantity'])
                                  });
                                  Firestore.instance
                                      .collection('reservations')
                                      .document()
                                      .setData({
                                    'user': LocalUserInfo.username,
                                    'product_id': widget.document.documentID,
                                    'quantity': num.parse(
                                        _fbKey.currentState.value['quantity'])
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              })),
                    ],
                  ),
                ))
            : NoInternet(_checkInternetAccess));
  }
}
