import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> _authenticateUserAndLogin(
      BuildContext ctx, BuildContext snackCtx) async {
    String inputEmail = email.text.trim();
    String inputPassword = password.text.trim();

    try {
      await Auth.authenticateUser(inputEmail, inputPassword);
      bool isLoggedIn = await Auth.loggedIn();

      if (isLoggedIn) {
        Provider.of<UserModel>(ctx, listen: false).fetchUser();
        return Navigator.pushReplacementNamed(context, '/nav');
      }
    } catch (err) {
      Scaffold.of(snackCtx).showSnackBar(SnackBar(
          backgroundColor: LloudTheme.red,
          content: Text('Incorrect email or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(<Widget>[
      SizedBox(height: 80.0),
      Column(children: <Widget>[
        H1('Login!'),
      ]),
      SizedBox(
        height: 120.0,
      ),
      TextField(
        controller: email,
        decoration: InputDecoration(labelText: 'Email', filled: true),
      ),
      SizedBox(
        height: 12.0,
      ),
      TextField(
        controller: password,
        decoration: InputDecoration(labelText: 'Password', filled: true),
        obscureText: true,
      ),
      ButtonBar(
        children: <Widget>[
          Builder(
              builder: (snackCtx) => RaisedButton(
                    child: Text('Log in'),
                    onPressed: () async {
                      await _authenticateUserAndLogin(context, snackCtx);
                    },
                    textColor: LloudTheme.white,
                    color: LloudTheme.red,
                  ))
        ],
      )
    ]);
  }
}
