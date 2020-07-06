import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:marketplace/src/alerts/username.dart';
import 'package:marketplace/src/screens/buy.dart';
import 'package:marketplace/src/screens/sell.dart';
import 'package:marketplace/src/utils/user.dart';
import 'package:marketplace/src/utils/username.dart';
import 'package:marketplace/src/utils/background.dart';
import 'package:marketplace/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  await LocalUserInfo.retrieveUsername();
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Giełda spożywcza",
        theme: ThemeData(
            //primarySwatch: Colors.teal,
            //brightness: Brightness.dark,
            primaryColor: Colors.indigo[400],
            accentColor: Colors.indigo[400],
            fontFamily: 'Raleway'),
        home: Scaffold(
            body: Builder(
                builder: (context) => Stack(
                      children: <Widget>[
                        Background(color1: Colors.amber, color2: Colors.blue),
                        UsernameBuilder(),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Card(
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                    color: Colors.black26,
                                    width: 5,
                                  )),
                                  child: Container(
                                      width: 250,
                                      child: FittedBox(
                                          child: FloatingActionButton.extended(
                                        icon: Icon(Icons.search),
                                        label: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text('REZERWUJ')),
                                        onPressed: () {
                                          if (LocalUserInfo.isUsernameSet())
                                            Utils.pushScreen(
                                                context, BuyScreen());
                                          else
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return UsernameAlert(
                                                    onSuccess: () =>
                                                        Utils.pushScreen(
                                                            context,
                                                            BuyScreen()),
                                                  );
                                                });
                                        },
                                        heroTag: null,
                                      )))),
                              Container(
                                height: 60,
                              ),
                              Card(
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                    color: Colors.black26,
                                    width: 5,
                                  )),
                                  child: Container(
                                      width: 250,
                                      child: FittedBox(
                                          child: FloatingActionButton.extended(
                                        icon: Icon(OMIcons.shoppingCart),
                                        label: Text('WYSTAWIAJ'),
                                        onPressed: () {
                                          if (LocalUserInfo.isUsernameSet())
                                            Utils.pushScreen(
                                                context, SellScreen());
                                          else
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return UsernameAlert(
                                                    onSuccess: () =>
                                                        Utils.pushScreen(
                                                            context,
                                                            SellScreen()),
                                                  );
                                                });
                                        },
                                        heroTag: null,
                                      ))))
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        )
                      ],
                    ))));
  }
}
