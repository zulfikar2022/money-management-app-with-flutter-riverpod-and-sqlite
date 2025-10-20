import 'package:flutter/cupertino.dart';
import 'package:flutter_money_management_app/auth/auth_service.dart';
import 'package:flutter_money_management_app/auth/logout_view.dart';
import 'package:flutter_money_management_app/providers/auth_service_provider.dart';
import 'package:flutter_money_management_app/screens/tabs_screen/tabs_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstPage extends ConsumerStatefulWidget {
  const FirstPage({super.key});

  @override
  ConsumerState<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      // stream: ref.watch(authServiceProvider).authStateChanges,
      builder: (ctx, snapshot) {
        print("Inside the stream builder");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasData) {
          return TabsScreen();
        } else {
          print("error occurs from the first page");
          return AuthWrapper();
        }
      },
    );
  }
}
