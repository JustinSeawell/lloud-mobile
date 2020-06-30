import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class RemainingLikes extends StatefulWidget {
  @override
  _RemainingLikesState createState() => _RemainingLikesState();
}

class _RemainingLikesState extends State<RemainingLikes> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
        onPressed: () {
          Navigator.pushNamed(context, '/likes');
        },
        textColor: LloudTheme.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.favorite,
                size: 22,
              ),
            ),
          ],
        ));
  }
}
