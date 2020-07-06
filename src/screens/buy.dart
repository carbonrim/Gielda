import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/search_products.dart';
import 'package:marketplace/src/utils/show_products.dart';

class BuyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyScreenState();
  }
}

class BuyScreenState extends State<BuyScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text('Rezerwuj'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )),
            body: Stack(
              children: <Widget>[
                Center(
                    child: Opacity(
                  opacity: 0.25,
                  child: Icon(
                    Icons.search,
                    size: 200,
                  ),
                )),
                search == '' ? ShowProducts() : SearchProducts(search),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Card(
                        shape: StadiumBorder(
                            side: BorderSide(
                          color: Theme.of(context).accentColor.withAlpha(150),
                          width: 5,
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Szukaj...'),
                                textInputAction: TextInputAction.search,
                                style: new TextStyle(
                                  fontSize: 18,
                                ),
                                onChanged: (text) {
                                  search = text;
                                },
                                onSubmitted: (text) {
                                  setState(() {});
                                },
                              ),
                            )),
                            Padding(
                                padding: EdgeInsets.all(3),
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  color: Theme.of(context).accentColor,
                                  iconSize: 30,
                                ))
                          ],
                        ))),
              ],
            )));
  }
}
