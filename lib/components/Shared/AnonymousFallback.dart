import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotube/provider/Auth.dart';

class AnonymousFallback extends ConsumerWidget {
  final Widget? child;
  const AnonymousFallback({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isLoggedIn = ref.watch(authProvider.select((s) => s.isLoggedIn));

    if (isLoggedIn && child != null) return child!;
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
