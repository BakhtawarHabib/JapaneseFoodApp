import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japfooduser/grocerry_kit/home_page.dart';
import 'package:provider/provider.dart';
import 'grocerry_kit/SignIn.dart';
import 'grocerry_kit/sub_pages/cartPage.dart';
import 'providers/cart.dart';
import 'providers/category.dart';
import 'providers/product.dart';
import 'providers/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black87));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Category(),
        ),
        ChangeNotifierProvider.value(
          value: Product(),
        ),
        ChangeNotifierProvider.value(
          value: User(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Japanese Food Online',
        theme: ThemeData(
          primaryColor: Colors.black,
          buttonColor: Colors.black87,
          accentColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return HomePage();
            }
            return SignInPage();
          },
        ),
        routes: {
          SignInPage.routeName: (context) => SignInPage(),
          '/grocerry/cart': (context) => CartPage(),
        },
      ),
    );
  }
}
