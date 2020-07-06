import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/firestore_helper.dart';
import 'package:marketplace/src/utils/product_tile.dart';
import 'package:marketplace/src/utils/utils.dart';

class SearchProducts extends StatelessWidget {
  final String query;
  int promotedCount = 0;

  SearchProducts(this.query);

  Future<List<DocumentSnapshot>> _getResults() async {
    var title = query.toLowerCase();
    var words = title.split(RegExp('\\s+'));
    List<DocumentSnapshot> result = List();

    for (var word in words) {
      if (word.length > 4) word = Utils.cut(word, 2);
      var promoted = await FirestoreHelper.searchPromotedProducts(10, word);
      FirestoreHelper.mergeProducts(result, promoted);
    }
    promotedCount = result.length;

    for (var word in words) {
      if (word.length > 4) word = Utils.cut(word, 2);
      var promoted = await FirestoreHelper.searchProducts(10, word);
      FirestoreHelper.mergeProducts(result, promoted);
    }
    return result;
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
              return Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Brak wyników',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 17,
                            ))
                      ]));
        }
        return null;
      },
    );
  }
}
