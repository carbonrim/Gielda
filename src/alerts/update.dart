import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marketplace/src/alerts/nointernet.dart';
import 'package:marketplace/src/utils/utils.dart';

class UpdateAlert extends StatefulWidget {
  final DocumentSnapshot document;
  UpdateAlert(this.document);
  @override
  State<StatefulWidget> createState() {
    return UpdateAlertState();
  }
}

class UpdateAlertState extends State<UpdateAlert> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool hasInternetAccess = false;
  TextEditingController quantityCtrl;

  Future<void> _checkInternetAccess() async {
    var result = await Utils.hasAccessToInternet();
    setState(() {
      hasInternetAccess = result;
    });
  }

  @override
  void initState() {
    _checkInternetAccess();
    quantityCtrl = TextEditingController(
        text: widget.document['quantity'].toStringAsFixed(2));
    super.initState();
  }

  replaceCommas() {
    if (quantityCtrl.text != null && quantityCtrl.text.contains(',')) {
      quantityCtrl.text = quantityCtrl.text.replaceAll(new RegExp(r','), '.');
    }
  }

  updateProduct() async {
    await widget.document.reference.updateData({
      'quantity': num.parse(_fbKey.currentState.value['quantity']),
      'date': DateTime.now()
    });
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
                      Text('Aktualizuj ilość produktu'),
                      FormBuilderTextField(
                        attribute: 'quantity',
                        controller: quantityCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Ilość (kg)"),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Pole nie może być puste'),
                          FormBuilderValidators.numeric(
                              errorText: 'Wprowadź liczbę')
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          child: FloatingActionButton.extended(
                              icon: Icon(Icons.done),
                              label: Text('Gotowe'),
                              onPressed: () {
                                replaceCommas();
                                _fbKey.currentState.save();
                                if (_fbKey.currentState.validate()) {
                                  updateProduct();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              })),
                    ],
                  ),
                ))
            : NoInternet(_checkInternetAccess));
  }

  @override
  void dispose() {
    quantityCtrl.dispose();
    super.dispose();
  }
}
