import 'package:flutter/material.dart';
import 'package:flutter_pagecall/flutter_pagecall.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Transfer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController roomIdFieldController = TextEditingController();
  TextEditingController accessTokenFieldController = TextEditingController();
  TextEditingController queryParamsFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Setting'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              TextField(
                controller: roomIdFieldController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: 'Enter Room Id',
                ),
              ),
              TextField(
                controller: accessTokenFieldController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: 'Enter Access Token',
                ),
              ),
              TextField(
                controller: queryParamsFieldController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: 'Enter Query Params (Optional, a=1&b=2&c=3)',
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Enter Room'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(
                      roomId: roomIdFieldController.text,
                      accessToken: accessTokenFieldController.text,
                      queryParams: queryParamsFieldController.text),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String roomId;
  final String accessToken;
  final String queryParams;

  const SecondScreen(
      {super.key,
      required this.roomId,
      this.accessToken = '',
      this.queryParams = ''});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController messageFieldController = TextEditingController();

  PagecallViewController? pagecallViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagecall Room'),
      ),
      body: Column(
        children: [
          TextField(
            controller: messageFieldController,
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
              roomId: widget.roomId,
              accessToken: widget.accessToken,
              queryParams: widget.queryParams,
              onViewCreated: (controller) {
                pagecallViewController = controller;
              },
              onMessage: (message) {
                debugPrint('Received message=$message');
                Fluttertoast.showToast(msg: 'Message from Native: $message');
              },
              onLoaded: () {
                debugPrint('Pagecall loaded');
                Fluttertoast.showToast(msg: 'Pagecall loaded');
              },
              onTerminated: (reason) {
                debugPrint('Pagecall terminated: $reason');
                Fluttertoast.showToast(msg: 'Pagecall terminated: $reason');
              },
              onError: (error) {
                debugPrint('Pagecall error: $error');
                Fluttertoast.showToast(msg: 'Pagecall error: $error');
              },
              debuggable: true,
            ),
          ),
        ],
      ),
    );
  }

  void _invokeSendMessage(String message) {
    debugPrint('invoking with message=$message');

    pagecallViewController?.sendMessage(message);
    messageFieldController.clear();
  }
}
