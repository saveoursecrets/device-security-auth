import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keychain_signin/keychain_signin.dart';
import 'package:keychain_signin/localization_model.dart';

const serviceName = "com.saveoursecrets.keychain-sigin";
const accountName = "test-account";

void main() {
  runApp(MaterialApp(
    title: 'Keychain Signin',
    home: Scaffold(
      appBar: AppBar(
        title: const Text('KeychainSignin Demo'),
      ),
      body: const HomeWidget(),
    ),
  ));
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _canAuthenticate = false;
  final _keychainSigninPlugin = KeychainSignin();
  String _password = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    final localization = LocalizationModel(
        promptDialogTitle: "title for dialog",
        promptDialogReason: "reason for prompting biometric",
        cancelButtonTitle: "cancel"
    );
    _keychainSigninPlugin.setLocalizationModel(localization);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Text('Service: $serviceName'),
          const SizedBox(height: 16),
          Text('Account: $accountName'),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            onChanged: (value) {
              setState(() => _password = value);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Create password'),
            onPressed: () async {
              final saved = await _keychainSigninPlugin.createAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
                password: _password,
              );

              if (saved) {
                final snackBar = SnackBar(
                  content: Text('Account password saved'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Read password'),
            onPressed: () async {
              final password = await _keychainSigninPlugin.readAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
              );
              if (password != null) {
                final snackBar = SnackBar(
                  content: Text('Account password read: $password'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Delete password'),
            onPressed: () async {
              final deleted = await _keychainSigninPlugin.deleteAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
              );

              if (deleted) {
                final snackBar = SnackBar(
                  content: Text('Account password deleted'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
    );
  }
}
