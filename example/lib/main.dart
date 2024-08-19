import 'package:flutter/material.dart';
import 'package:device_security_auth/device_security_auth.dart';

const serviceName = "com.saveoursecrets.device-security-auth";
const accountName = "test-account";

void main() {
  runApp(MaterialApp(
    title: 'Device Security Auth',
    home: Scaffold(
      appBar: AppBar(
        title: const Text('DeviceSecurityAuth Demo'),
      ),
      body: const HomeWidget(),
    ),
  ));
}

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({super.key, required this.plugin});

  final DeviceSecurityAuth plugin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: plugin.getDeviceSecurityType(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.toString());
            }
            return const SizedBox.shrink();
          },
        ),
        FutureBuilder(
          future: plugin.canAuthenticate(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("canAuthenticate: ${snapshot.data!.toString()}");
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _plugin = DeviceSecurityAuth(serviceName: serviceName);
  String _password = "";

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const Text('Service: $serviceName'),
          const SizedBox(height: 16),
          const Text('Account: $accountName'),
          const SizedBox(height: 16),
          DeviceInfo(plugin: _plugin),
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
              final saved = await _plugin.upsertAccountPassword(
                accountName: accountName,
                password: _password,
              );

              if (saved) {
                const snackBar = SnackBar(
                  content: Text('Account password upserted'));
                messenger.showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Create password'),
            onPressed: () async {
              final saved = await _plugin.createAccountPassword(
                accountName: accountName,
                password: _password,
              );

              if (saved) {
                const snackBar = SnackBar(
                  content: Text('Account password saved'));
                messenger.showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Read password'),
            onPressed: () async {
              final password = await _plugin.readAccountPassword(
                accountName: accountName,
              );
              if (password != null) {
                final snackBar = SnackBar(
                  content: Text('Account password read: $password'));
                messenger.showSnackBar(snackBar);
              } else {
                const snackBar = SnackBar(
                  content: Text('Password does not exist!'));
                messenger.showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Update password'),
            onPressed: () async {
              final updated = await _plugin.updateAccountPassword(
                accountName: accountName,
                password: _password,
              );

              if (updated) {
                const snackBar = SnackBar(
                  content: Text('Account password saved'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Delete password'),
            onPressed: () async {
              final deleted = await _plugin.deleteAccountPassword(
                accountName: accountName,
              );

              if (deleted) {
                const snackBar = SnackBar(
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
