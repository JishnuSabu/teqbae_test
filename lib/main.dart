import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:teqbae_test/controller/service/theme/theme_service.dart';
import 'package:teqbae_test/core/app_providers.dart';
import 'package:teqbae_test/core/network/base_url.dart';
import 'package:teqbae_test/core/network/mock_http_server.dart';
import 'package:teqbae_test/core/routes/app_router.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/core/sync/sync_service.dart';
import 'package:teqbae_test/core/themes/app_theme_style.dart';

void runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  // Safely handle google_fonts offline / fetch exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    final errStr = error.toString();
    final stackStr = stack.toString();
    if (errStr.contains('google_fonts') ||
        errStr.contains('fonts.gstatic.com') ||
        stackStr.contains('google_fonts')) {
      return true; // Handled gracefully
    }
    return false;
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    final errStr = details.exception.toString();
    final stackStr = details.stack.toString();
    if (errStr.contains('google_fonts') ||
        errStr.contains('fonts.gstatic.com') ||
        stackStr.contains('google_fonts')) {
      return; // Handled gracefully
    }
    FlutterError.presentError(details);
  };

  // Initialize network monitor for auto-sync
  SyncService().initConnectivityMonitor(
    onAutoSync: () async {
      await SyncService().syncPendingEvents();
    },
  );

  runApp(const AppProviders(child: Hrms()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await MockHttpServer.start(port: 8085);
  BaseUrl.basePathUrl = MockHttpServer.baseUrl;
  runMainApp();
}

class Hrms extends StatefulWidget {
  const Hrms({super.key});

  @override
  State<Hrms> createState() => _HrmsState();
}

class _HrmsState extends State<Hrms> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setOrientation();
    });
  }

  void _setOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didChangePlatformBrightness() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.themeMode == ThemeService.SYSTEM_MODE) {
      themeProvider.updateThemeBasedOnMode(context);
    }
    super.didChangePlatformBrightness();
  }

  Future<void> _initializeTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.initialize(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final ThemeMode materialThemeMode = switch (themeProvider.themeMode) {
          0 => ThemeMode.system,
          1 => ThemeMode.light,
          2 => ThemeMode.dark,
          _ => ThemeMode.system,
        };
        return MaterialApp.router(
          routerConfig: appRouter,
          themeMode: materialThemeMode,
          theme: ThemeStyle.appThemeStyle(context, false),
          darkTheme: ThemeStyle.appThemeStyle(context, true),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
