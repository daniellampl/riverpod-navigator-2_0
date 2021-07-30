import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/app_route_information_parser.dart';
import 'navigation/app_router_delegate.dart';
import 'config/configure_nonweb.dart' if (dart.library.html) 'config/configure_web.dart';

void main() {
  configureApp();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: AppRouterDelegate(ref),
      routeInformationParser: AppRouteInformationParser(ref),
    );
  }
}
