import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnonymousFallback extends StatelessWidget {
  const AnonymousFallback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You're not logged in"),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text("Login with Spotify"),
            onPressed: () => GoRouter.of(context).push("/settings"),
          )
        ],
      ),
    );
  }
}
