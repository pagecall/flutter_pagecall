import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pagecall_flutter/pagecall_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TextEditingController _textFieldController;
  PagecallViewController? _pagecallViewController;

  @override
  void initState() {
    super.initState();

    _textFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _textFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PagecallView example app'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: "Submit to invoke sendMessage",
              ),
              keyboardType: TextInputType.text,
              onSubmitted: _invokeSendMessage,
            ),
            Expanded(
              child: PagecallView(
                mode: "meet",
                roomId: "6486b3db6d4b09eaf7a6f456",
                accessToken: Platform.isAndroid
                    ? "3UXS_RTalT6VCIs5AuSnE-8yHIocRgny"
                    : "cd_FQbSbZAr8LMcp4Zd4GbDAbDbKpT7R",
                onViewCreated: (controller) {
                  _pagecallViewController = controller;
                },
                onMessageReceived: (message) {
                  // TODO: when null?
                  debugPrint('Received message=$message');
                  Fluttertoast.showToast(
                      msg: 'Message from Native: $message');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _invokeSendMessage(String message) {
    debugPrint('invoking with message=$message');

    _pagecallViewController?.sendMessage(message);
    _textFieldController.clear();
  }
}
