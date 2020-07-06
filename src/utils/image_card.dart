import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/screens/image.dart';
import 'package:marketplace/src/utils/utils.dart';

class ImageCard extends StatelessWidget {
  final String url;
  ImageCard(this.url);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 3, right: 3),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                width: 100,
                height: 150,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onTap: () =>
                        Utils.pushScreen(context, ImageViewScreen(url)),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: url,
                              placeholder: (context, url) => SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            )))))));
  }
}
