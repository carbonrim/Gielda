import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marketplace/src/utils/empty.dart';
import 'package:marketplace/src/utils/user.dart';

class UsernameBuilder extends StatelessWidget {
  UsernameBuilder();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LocalUserInfo.isUsernameSet()
            ? (orientation == Orientation.portrait
                ? Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(7),
                                child: AutoSizeText(
                                  'Witaj, ' + LocalUserInfo.username + '!',
                                  style: TextStyle(
                                    fontSize: 28,
                                  ),
                                  maxLines: 1,
                                  overflowReplacement: Text(
                                    'Witaj!',
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                )))))
                : Empty())
            : Empty();
      },
    );
  }
}
