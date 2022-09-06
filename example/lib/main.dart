import 'package:flutter/material.dart';
import 'package:plugin_screeb/plugin_screeb.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    PluginScreeb.initSdk(
        "082b7590-1621-4f72-8030-731a98cd1448",
        "5c62c145-91f1-4abd-8aa2-63d7847db1e1",
        "flutter_plugin@screeb.app",
        <String, dynamic>{
          'isConnected': false,
          'age': 29,
          'product' : 'iPhone 13',
          'email' : 'flutter_plugin@screeb.app',
          'born' : DateTime.now()
        }
    );
  }

  void _setIdentity(String userId, Map<String, dynamic>? properties){
    PluginScreeb.setIdentity(userId, properties);
    log("SetIdentity");
  }

  void _sendTrackingEvent(String eventId,  Map<String, dynamic>? properties){
    PluginScreeb.trackEvent(eventId, properties);
    log("TrackingEvent");
  }

  void _sendTrackingScreen(String screen,  Map<String, dynamic>? properties){
    PluginScreeb.trackScreen(screen, properties);
    log("TrackingScreen");
  }

  void _visitorProperty(Map<String, dynamic>? properties){
    PluginScreeb.setProperty(properties);
    log("VisitorProperties");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Screeb Commands"),
              ElevatedButton(
                child: const Text('set identity'),
                onPressed: () => _setIdentity('iosflutterId', <String, dynamic>{
                  'isConnected': false,
                  'age': 29,
                  'product' : 'iPhone 13',
                }),
              ),
              ElevatedButton(
                child: const Text('send tracking event'),
                onPressed: () => _sendTrackingEvent("eventId", <String, dynamic>{
                  'isConnected': true,
                  'age': 27,
                  'company' : 'Screeb',
                  'technology' : 'iOS',
                  'flutterAccount' : true
                }),
              ),
              ElevatedButton(
                child: const Text('send tracking screen'),
                onPressed: () => _sendTrackingScreen("MainScreen", <String, dynamic>{
                  'isConnected': true,
                  'age': 28,
                  'company' : 'Screeb',
                  'technology' : 'Android',
                  'flutterAccount' : false
                }),
              ),
              ElevatedButton(
                child: const Text('send visitor property'),
                onPressed: () => _visitorProperty(<String, dynamic>{
                  'isConnected': false,
                  'age': 29,
                  'product' : 'iPhone 13',
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
