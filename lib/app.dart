import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:radiostring/pages/home.dart';
import 'package:radiostring/pages/splash_screen.dart';
import 'package:radiostring/themes/custom_theme.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.green,
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.red, canvasColor: Color.fromRGBO(221, 221, 221, 1.0));

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new RadioString());
  });
}

class RadioString extends StatefulWidget {
  @override
  State createState() => _RadioStringState();
}

class _RadioStringState extends State<RadioString> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
      title: 'Radiostring',
      debugShowCheckedModeBanner: false,
      theme: customThemeData,
      home: SplashScreen(),
      routes: {
        '/home': (BuildContext context) => Home(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        return null;
      },
    ));
  }
}
