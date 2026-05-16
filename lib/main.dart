import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/jadwal_screen.dart';
import 'screens/config_screen.dart';
import 'services/notification_service.dart';
import 'services/tray_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
  await NotificationService().init();
  
  // Window manager and Tray is only for Desktop
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await TrayService().init();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(400, 600));
      await windowManager.setMaximumSize(const Size(700, 1000));
      await windowManager.setIcon('assets/app_icon.png');
      await windowManager.show();
      await windowManager.focus();
      // Prevent closing when clicking X, we'll hide it instead
      await windowManager.setPreventClose(true);
    });
  }

  runApp(
    // ProviderScope is required by Riverpod to store the state of the providers
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      await windowManager.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Salat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const JadwalScreen(),
        '/config': (context) => const ConfigScreen(),
      },
    );
  }
}
