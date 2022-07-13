import 'package:copy_watch_face/generated/l10n.dart';
import 'package:copy_watch_face/pages/ble.dart';
import 'package:copy_watch_face/pages/health.dart';
import 'package:copy_watch_face/pages/index.dart';
import 'package:copy_watch_face/pages/pay.dart';
import 'package:copy_watch_face/pages/set_target.dart';
import 'package:copy_watch_face/pages/zepp_life.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class App {
  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    observers: [App.routeObserver],
    routes: <GoRoute>[
      GoRoute(path: "/", builder: (ctx, state) => const IndexPage()),
      GoRoute(path: "/health", builder: (ctx, state) => const HealthPage()),
      GoRoute(
        path: "/zepp_life",
        builder: (ctx, state) => const ZeppLifePage(),
      ),
      GoRoute(path: "/ble_install", builder: (ctx, state) => const BlePage()),
      GoRoute(
        path: "/set_target",
        builder: (ctx, state) => const SetTargetPage(),
      ),
      GoRoute(
        path: "/pay",
        builder: (ctx, state) => const PayPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: '偷天换日',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
