import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/screens/form.dart';
import 'package:marketplace/src/utils/sell_products.dart';
import 'package:marketplace/src/utils/user.dart';

class SellScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SellScreenState();
  }
}

class SellScreenState extends State<SellScreen> {
  bool hasProducts = true;

  checkHasProducts() async {
    QuerySnapshot result = await Firestore.instance
        .collection('products')
        .where('username', isEqualTo: LocalUserInfo.username)
        .limit(1)
        .getDocuments();
    setState(() {
      hasProducts = result.documents.isNotEmpty;
    });
  }

  @override
  void initState() {
    checkHasProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text('Wystawiaj'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )),
            floatingActionButton: FloatingActionButton.extended(
                label: Text('Dodaj produkt',
                    style: TextStyle(
                      fontSize: 17,
                    )),
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new FormScreen()),
                    ).then((value) {
                      checkHasProducts();
                      setState(() {});
                    })),
            body: Stack(
              children: <Widget>[
                Center(
                    child: Opacity(
                  opacity: 0.25,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 200,
                  ),
                )),
                hasProducts
                    ? SellProducts()
                    : Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  'Tu jeszcze nic nie ma,\nDodaj produkt aby rozpocząć',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16,
                                  ))
                            ]))
              ],
            )));
  }
}
