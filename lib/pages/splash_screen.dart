import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:radiostring/blocs/station_bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => checkInternet()
    );
    super.initState();
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
          await stationsBloc.getFavourites();
          await stationsBloc.getCountries();
          await stationsBloc.getStations();
          Navigator.pushReplacementNamed(context, '/home');
    } else {
      showNoInternet(context, 'No internet connection!');
    }
  }

  void showNoInternet(BuildContext context, String error_content) {
    Flushbar(
      backgroundColor: Colors.white,
      messageText: Text(error_content,
        style: TextStyle(
          fontFamily: 'Jost-Regular',
          color: Colors.black
        )
      ),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text(
          'TRY AGAIN',
          style: TextStyle(color: Theme.of(context).accentColor,
          fontFamily: 'Jost-Medium'),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
          checkInternet();
        },
      ),
      duration: Duration(minutes: 1),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(72, 100, 170, 1)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Radio String',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Jost-Medium',
                              fontSize: MediaQuery.of(context).size.width / 10),
                        ),
                      ),
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _submitForm() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'No Internet',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Text('You are Offline. Please Provide Internet Connection'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
