import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace/src/utils/user.dart';
import 'package:marketplace/src/utils/utils.dart';

class FirestoreHelper {
  static Future<List<DocumentSnapshot>> getPromotedProducts(int limit) async {
    DateTime now = await Utils.getTime();
    var result = await Firestore.instance
        .collection('products')
        .orderBy('promotedUntil', descending: true)
        .where('promotedUntil', isGreaterThan: now)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static Future<List<DocumentSnapshot>> searchPromotedProducts(
      int limit, String word) async {
    DateTime now = await Utils.getTime();
    var result = await Firestore.instance
        .collection('products')
        .where('keywords', arrayContains: word)
        .orderBy('promotedUntil', descending: true)
        .where('promotedUntil', isGreaterThan: now)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static Future<List<DocumentSnapshot>> getUsersPromotedProducts(
      int limit) async {
    DateTime now = await Utils.getTime();
    var result = await Firestore.instance
        .collection('products')
        .orderBy('promotedUntil', descending: true)
        .where('promotedUntil', isGreaterThan: now)
        .where('username', isEqualTo: LocalUserInfo.username)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static Future<List<DocumentSnapshot>> getProducts(int limit) async {
    var result = await Firestore.instance
        .collection('products')
        .orderBy('date', descending: true)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static Future<List<DocumentSnapshot>> searchProducts(
      int limit, String word) async {
    var result = await Firestore.instance
        .collection('products')
        .orderBy('date', descending: true)
        .where('keywords', arrayContains: word)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static Future<List<DocumentSnapshot>> getUserProducts(int limit) async {
    var result = await Firestore.instance
        .collection('products')
        .orderBy('date', descending: true)
        .where('username', isEqualTo: LocalUserInfo.username)
        .limit(limit)
        .getDocuments();
    return result.documents;
  }

  static List<DocumentSnapshot> mergeProducts(
      List<DocumentSnapshot> list1, List<DocumentSnapshot> list2) {
    List<DocumentSnapshot> result = list1;
    for (var document in list2)
      if (result.singleWhere(
              (v) =>
                  v['name'] == document['name'] &&
                  v['username'] == document['username'],
              orElse: () => null) ==
          null) result.add(document);
    return result;
  }
}
