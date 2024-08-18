import 'package:flutter/material.dart';
import 'package:device_security_auth/device_security_auth.dart';

const serviceName = "com.saveoursecrets.device-security-auth";
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
  final _keychainSigninPlugin = KeychainSignin();
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const Text('Service: $serviceName'),
          const SizedBox(height: 16),
          const Text('Account: $accountName'),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            onChanged: (value) {
              setState(() => _password = value);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Upsert password'),
            onPressed: () async {
              final saved = await _keychainSigninPlugin.upsertAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
                password: _password,
              );

              if (saved) {
                final snackBar = const SnackBar(
                  content: Text('Account password upserted'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Create password'),
            onPressed: () async {
              final saved = await _keychainSigninPlugin.createAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
                password: _password,
              );

              if (saved) {
                final snackBar = const SnackBar(
                  content: Text('Account password saved'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Read password'),
            onPressed: () async {
              final password = await _keychainSigninPlugin.readAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
              );
              if (password != null) {
                final snackBar = SnackBar(
                  content: Text('Account password read: $password'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                final snackBar = const SnackBar(
                  content: Text('Password does not exist!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Update password'),
            onPressed: () async {
              final updated = await _keychainSigninPlugin.updateAccountPassword(
                serviceName: serviceName,
                accountName: accountName,
                password: _password,
              );

              if (updated) {
                final snackBar = SnackBar(
                  content: Text('Account password saved'));
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
