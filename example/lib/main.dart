import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:livechatt/livechatt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiveChat',
      home: Support(),
    );
  }
}

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String _platformVersion = 'Unknown';
  final licenseNoTextController = TextEditingController();
  final groupIdTextController = TextEditingController();
  final visitorNameTextController = TextEditingController();
  final visitorEmailTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Livechat.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Support",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "License Number",
                    textAlign: TextAlign.left,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: licenseNoTextController,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Group Id",
                    textAlign: TextAlign.left,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: groupIdTextController,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Visitor Name",
                    textAlign: TextAlign.left,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: visitorNameTextController,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Visitor Email",
                    textAlign: TextAlign.left,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: visitorEmailTextController,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPress: () {
                    Livechat.beginChat(
                        licenseNoTextController.text,
                        groupIdTextController.text,
                        visitorNameTextController.text,
                        visitorEmailTextController.text);
                  },
                  title: "Start Live Chat",
                ),
                // Spacer(),
                Text('Running on: $_platformVersion\n'),
              ],
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: Text('Running on: $_platformVersion\n'),
      // ),
    );
  }
}

/// Custom button
class CustomButton extends StatelessWidget {
  final String title;
  final Function() onPress;

  CustomButton({
    Key key,
    @required this.title,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[500],
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextButton(
          onPressed: () {
            onPress();
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFFFFF),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
