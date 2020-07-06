import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/empty.dart';
import 'package:marketplace/src/utils/firestore_helper.dart';
import 'package:marketplace/src/utils/product_tile.dart';

class SellProducts extends StatelessWidget {
  int promotedCount = 0;

  Future<List<DocumentSnapshot>> _getResults() async {
    var promoted = await FirestoreHelper.getUsersPromotedProducts(100);
    promotedCount = promoted.length;
    var all = await FirestoreHelper.getUserProducts(100);
    return FirestoreHelper.mergeProducts(promoted, all);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getResults(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: CircularProgressIndicator())
                ]);
          case ConnectionState.done:
            if (snapshot.data.length != 0)
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, int index) {
                  return ProductTile(snapshot.data[index],
                      isPromoted: index < promotedCount);
                },
              );
            else
              return Empty();
        }
        return null;
      },
    );
  }
}
