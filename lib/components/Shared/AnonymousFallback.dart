import 'package:flutter/material.dart';

class AnonymousFallback extends StatelessWidget {
  const AnonymousFallback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("You're not logged in"));
  }
}
