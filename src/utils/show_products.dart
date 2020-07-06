import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/empty.dart';
import 'package:marketplace/src/utils/firestore_helper.dart';
import 'package:marketplace/src/utils/product_tile.dart';

class ShowProducts extends StatelessWidget {
  int promotedCount = 0;

  Future<List<DocumentSnapshot>> _getResults() async {
    var promoted = await FirestoreHelper.getPromotedProducts(20);
    promotedCount = promoted.length;

    if (promotedCount <= 10) {
      var regular = await FirestoreHelper.getProducts(10);
      return FirestoreHelper.mergeProducts(promoted, regular);
    } else {
      return promoted;
    }
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
                itemCount: snapshot.data.length + 1,
                itemBuilder: (_, int index) {
                  if (index == 0)
                    return Container(height: 70);
                  else
                    return ProductTile(snapshot.data[index - 1],
                        isPromoted: index <= promotedCount);
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
