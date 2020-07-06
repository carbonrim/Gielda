import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/src/screens/product.dart';
import 'package:marketplace/src/utils/empty.dart';
import 'package:marketplace/src/utils/user.dart';

class ProductTile extends StatelessWidget {
  final DocumentSnapshot document;
  final bool isPromoted;

  ProductTile(this.document, {this.isPromoted = false});

  String thumbnailUrl() {
    String urls = document['imageUrls'];
    return urls.split('#')[0];
  }

  _pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                onTap: () => _pushScreen(context, ProductScreen(document)),
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: thumbnailUrl(),
                              placeholder: (context, url) => SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            ))),
                    Container(
                      width: 15,
                    ),
                    Expanded(
                        child: AutoSizeText(
                      document['name'],
                      style: TextStyle(fontSize: 24),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                    isPromoted
                        ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.trending_up,
                              color: Colors.orangeAccent,
                              size: 40,
                            ))
                        : document['username'] == LocalUserInfo.username
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).accentColor,
                                  size: 40,
                                ))
                            : Empty(),
                  ],
                ))));
  }
}
