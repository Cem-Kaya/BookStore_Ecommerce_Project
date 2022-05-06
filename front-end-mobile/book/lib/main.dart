import 'package:bookstore/pages/basket.dart';
import 'package:bookstore/pages/sign_in.dart';
import 'package:bookstore/root.dart';
import 'package:bookstore/services/basket_data.dart';
import 'package:bookstore/services/user_logged_data.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/pages/sign_up.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
     BaseApp()
  );
}
class BaseApp extends StatefulWidget {
  const BaseApp({Key? key}) : super(key: key);

  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ListenableProvider<Basket>(
      create: (BuildContext context) { return Basket(); },),
      ListenableProvider<logged_in_user >(create: (BuildContext context) { return logged_in_user(); },)
    ],
    child: MaterialApp(
        routes: {
        '/': (context) => const Root(),
        '/signIn': (context) => const SignIn(),
        '/signUp': (context) => const SignUp()
        },
    )
    );

  }
}