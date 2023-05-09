import 'package:flutter/material.dart';
import 'package:personal_expenses_2/constants.dart';
import 'package:personal_expenses_2/home_navigator.dart';
import 'package:personal_expenses_2/screens/home.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // This ThemeData is used to store the app's theme configuations, for exp: We set the primary
      // and asccent colors here, and then we can use them in the app.
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kAccentColor,
        primarySwatch: kSwatchColor,
        fontFamily: 'Raleway',
      ),
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      home: HomeNavigator(),
      // Here we define the routes for the app, we will have the route name as the key, and the pages as the value.
      routes: {
        Home.routeName: (ctx) => Home(),
        HomeNavigator.routeName: (ctx) => HomeNavigator(),
      },
    );
  }
}
