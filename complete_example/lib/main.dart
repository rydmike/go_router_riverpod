import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'riverpod_logger.dart';
import 'router.dart';

void main() {
  runApp(
    const ProviderScope(observers: [RiverpodLogger()], child: MyAwesomeApp()),
  );
}

class MyAwesomeApp extends ConsumerWidget {
  const MyAwesomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRouter = ref.watch(routerProvider);

    if (asyncRouter.hasValue) {
      final router = asyncRouter.requireValue;
      return MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        title: 'flutter_riverpod + go_router Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
    }

    return asyncRouter.maybeWhen(
      error: (error, stackTrace) {
        print(error);
        return const Text("Something went very, very wrong.");
      },
      orElse: () => const CircularProgressIndicator(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your phenomenal app")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Home Page"),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Login Page"),
            ElevatedButton(
              onPressed: () async {
                ref.read(authProvider.notifier).login(
                      "myEmail",
                      "myPassword",
                    );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Splash Page")),
    );
  }
}