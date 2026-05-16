import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  String _getIconPath() {
    const String assetPath = 'assets/app_icon.png';
    
    // Check if running inside a Snap
    final String? snapPath = Platform.environment['SNAP'];
    if (snapPath != null) {
      // Path inside Snap: /snap/jadwal-salat/current/data/flutter_assets/assets/app_icon.png
      return p.join(snapPath, 'data', 'flutter_assets', assetPath);
    }

    // Fallback for local development
    if (Platform.isLinux) {
      final String executableDir = p.dirname(Platform.resolvedExecutable);
      final String localPath = p.join(executableDir, 'data', 'flutter_assets', assetPath);
      if (File(localPath).existsSync()) return localPath;
    }

    return Platform.isWindows ? 'assets/app_icon.ico' : assetPath;
  }

  Future<void> init() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) return;

    await trayManager.setIcon(_getIconPath());
    
    List<MenuItem> items = [
      MenuItem(
        key: 'show_window',
        label: 'Show App',
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit_app',
        label: 'Exit',
      ),
    ];
    await trayManager.setContextMenu(Menu(items: items));
    trayManager.addListener(this);
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      windowManager.show();
      windowManager.focus();
    } else if (menuItem.key == 'exit_app') {
      await windowManager.destroy();
    }
  }
}
