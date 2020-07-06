import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/src/alerts/nointernet.dart';
import 'package:marketplace/src/utils/utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoteAlert extends StatefulWidget {
  final DocumentSnapshot document;
  PromoteAlert(this.document);
  @override
  State<StatefulWidget> createState() {
    return PromoteAlertState();
  }
}

class PromoteAlertState extends State<PromoteAlert> {
  bool hasInternetAccess = false;
  double _sliderValue = 1.0;

  Future<void> _checkInternetAccess() async {
    var result = await Utils.hasAccessToInternet();
    setState(() {
      hasInternetAccess = result;
    });
  }

  var durations = [1, 7, 31];
  var productIDs = ['promuj1', 'promuj2', 'promuj3'];

  InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool connectionAvailable = false;

  @override
  void initState() {
    initInAppPurchases();
    _checkInternetAccess();
    super.initState();
  }

  initInAppPurchases() async {
    _subscription = InAppPurchaseConnection.instance.purchaseUpdatedStream
        .listen((purchases) {
      handlePurchases(purchases);
    });
    connectionAvailable = await _connection.isAvailable();
    getProducts();
  }

  getProducts() async {
    if (!connectionAvailable) return;
    ProductDetailsResponse response =
        await _connection.queryProductDetails(Set.from(productIDs));
    _products = response.productDetails;
  }

  purchaseProduct(String productID) {
    if (!connectionAvailable) {
      Fluttertoast.showToast(
          msg: "Brak połączenia z serwerem!", fontSize: 14.0);
      return;
    }
    ProductDetails toPurchase = _products
        .firstWhere((ProductDetails product) => product.id == productID);
    print(toPurchase.description);
    PurchaseParam purchaseParam = PurchaseParam(productDetails: toPurchase);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }

  onProductPurchased(String productID) async {
    var duration = durations[productIDs.indexOf(productID)];
    DateTime now = await Utils.getTime();
    await widget.document.reference.updateData({
      'promotedUntil': now.add(Duration(days: duration)),
    });
  }

  void handlePurchases(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.error) {
        Fluttertoast.showToast(
            msg: "Transakcja nie zakończona.",
            backgroundColor: Colors.indigo[400],
            textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        onProductPurchased(purchaseDetails.productID);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: hasInternetAccess
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Promuj produkt',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.1,
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    'Twój produkt będzie promowany przez wybraną ilość dni - będzie wyświetlany w pierwszej kolejności na stronie głównej i przy wyszukiwaniach.',
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.9,
                  ),
                  Container(
                    height: 20,
                  ),
                  Opacity(
                      opacity: 0.7,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            '1 dzień',
                            textAlign: TextAlign.start,
                          )),
                          Text(
                            '7 dni',
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                              child: Text(
                            '31 dni',
                            textAlign: TextAlign.end,
                          )),
                        ],
                      )),
                  Slider(
                    min: 1.0,
                    max: 3.0,
                    value: _sliderValue,
                    onChanged: (v) {
                      setState(() => _sliderValue = v);
                    },
                    activeColor: Colors.orangeAccent,
                    inactiveColor: Colors.orange[100],
                    divisions: 2,
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.trending_up),
                    backgroundColor: Colors.orangeAccent,
                    heroTag: null,
                    onPressed: () {
                      purchaseProduct(productIDs[_sliderValue.floor() - 1]);
                    },
                  ),
                ],
              )
            : NoInternet(_checkInternetAccess));
  }
}
