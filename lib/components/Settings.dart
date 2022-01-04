import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/provider/Auth.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        title: const Text(
          "Settings",
        ),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headline4,
      ),
      body: Column(
        children: [
          Builder(builder: (context) {
            var auth = context.read<Auth>();
            return ElevatedButton(
              child: const Text("Logout"),
              onPressed: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                await localStorage.clear();
                auth.logout();
                Navigator.of(context).pop();
              },
            );
          })
        ],
      ),
    );
  }
}
