import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  final List<String> paths;
  final int index;

  ImageField({this.paths, this.index});

  @override
  State<StatefulWidget> createState() {
    return ImageFieldState();
  }
}

class ImageFieldState extends State<ImageField> {
  File _image;
  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
      if (widget.paths != null)
        widget.paths[widget.index] = image == null ? null : image.path;
    });
  }

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
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        contentPadding: EdgeInsets.all(10),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Opacity(
                                opacity: 0.7,
                                child: Container(
                                    width: double.infinity,
                                    child: FlatButton.icon(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        getImage(ImageSource.camera);
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                      ),
                                      label: Text('Aparat',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ))),
                            Divider(),
                            Opacity(
                                opacity: 0.7,
                                child: Container(
                                    width: double.infinity,
                                    child: FlatButton.icon(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          getImage(ImageSource.gallery);
                                        },
                                        icon: Icon(
                                          Icons.image,
                                          size: 50,
                                        ),
                                        label: Text('Galeria',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ))))),
                          ],
                        ),
                      );
                    }),
                child: _image == null
                    ? Center(
                        child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.black45,
                      ))
                    : Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ))),
              ),
            )));
  }
}
