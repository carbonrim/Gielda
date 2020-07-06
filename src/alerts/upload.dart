import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:marketplace/src/utils/user.dart';
import 'package:marketplace/src/utils/utils.dart';

class UploadAlert extends StatefulWidget {
  final List<String> imagePaths;
  final Map<String, dynamic> formFields;

  UploadAlert(this.imagePaths, this.formFields);

  @override
  State<StatefulWidget> createState() {
    return UploadAlertState();
  }
}

class UploadAlertState extends State<UploadAlert> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool uploading = false;
  bool uploaded = false;
  bool hasAccessToInternet = false;
  bool error = false;
  _checkInternetConnection() async {
    var result = await Utils.hasAccessToInternet();
    setState(() {
      hasAccessToInternet = result;
    });
    if (hasAccessToInternet) _uploadIfPossible();
  }

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  Future<String> _compressAndUpload(
      String path, String filename, int width, int height) async {
    File image = await FlutterNativeImage.compressImage(path,
        quality: 90, targetWidth: width, targetHeight: height);
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = storageRef.putFile(File(image.path));
    StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  String _randomName() {
    var random = Random.secure();
    var value = random.nextInt(1000000000);
    return value.toString() + '.jpg';
  }

  //thumbnailUrl#image1Url#image2Url??#image3Url??
  Future<String> _uploadImages() async {
    String result = '';
    for (String path in widget.imagePaths) {
      if (path == null) continue;
      if (result.length == 0) {
        String url = await _compressAndUpload(path, _randomName(), 200, 200);
        result += url + '#';
      }
      String url = await _compressAndUpload(path, _randomName(), 600, 800);
      result += url + '#';
    }
    return result;
  }

  String _cut(String word, int chars) {
    return word.substring(0, word.length - chars);
  }

  List<String> _createKeywords(String title) {
    List<String> result = List();
    title = title.toLowerCase();
    for (var word in title.split(' ')) {
      result.add(word);
      for (var i = 1; word.length > i + 2; i++) result.add(_cut(word, i));
    }
    return result;
  }

  Future<bool> _shouldUpload() async {
    QuerySnapshot result = await Firestore.instance
        .collection('products')
        .where('username', isEqualTo: LocalUserInfo.username)
        .where('name', isEqualTo: widget.formFields['name'])
        .limit(1)
        .getDocuments();
    return result.documents.isEmpty;
  }

  _uploadIfPossible() async {
    if (await _shouldUpload()) {
      if (!uploading) {
        uploading = true;
        DateTime now = await Utils.getTime();
        String urls = await _uploadImages();
        await Firestore.instance.collection('products').document().setData({
          'username': LocalUserInfo.username,
          'imageUrls': urls,
          'date': now,
          'keywords': _createKeywords(widget.formFields['name']),
          'category': widget.formFields['category'],
          'name': widget.formFields['name'],
          'description': widget.formFields['description'],
          'quantity': num.parse(widget.formFields['quantity']),
          'price': num.parse(widget.formFields['price']),
          'location': widget.formFields['location'],
          'contact': widget.formFields['contact'],
          'promotedUntil': now,
        });
        setState(() {
          uploaded = true;
        });
      }
    } else {
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: hasAccessToInternet
            ? (uploaded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Twój produkt został dodany!'),
                      Container(
                        height: 20,
                      ),
                      FloatingActionButton.extended(
                        heroTag: null,
                        icon: Icon(Icons.done),
                        label: Text('Gotowe'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                : error
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Posiadasz już produkt\no takiej nazwie',
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            height: 20,
                          ),
                          FloatingActionButton.extended(
                            heroTag: null,
                            icon: Icon(Icons.keyboard_backspace),
                            label: Text('Wróć'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Container(
                            height: 20,
                          ),
                          Text('Przetwarzanie...'),
                        ],
                      ))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Brak dostępu do internetu'),
                  Container(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: null,
                    icon: Icon(Icons.refresh),
                    label: Text('Odśwież'),
                    onPressed: () {
                      _checkInternetConnection();
                    },
                  )
                ],
              ));
  }
}
