import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tadllal/methods/auth_provider.dart';
import 'package:tadllal/pages/auth_pages/auth_pages.dart';
import 'package:tadllal/pages/home_page/home_page.dart';

void main() {
  runApp(const ProviderScope(child: TadllalApp()));
}

class TadllalApp extends HookConsumerWidget {
  const TadllalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: authState.when(
              data: (isAuthenticated) {
                return isAuthenticated
                    ? const HomePage()
                    : const AuthenticationPage();
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
