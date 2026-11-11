import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Asks the operating system for permission to show notifications. Push
/// delivery itself (FCM and APNs, EI-SW-09) arrives in S7.
abstract class NotificationPermission {
  /// True when notifications may be shown.
  Future<bool> request();
}

class SystemNotificationPermission implements NotificationPermission {
  @override
  Future<bool> request() async {
    final status = await Permission.notification.request();
    return status.isGranted || status.isProvisional;
  }
}

final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => SystemNotificationPermission(),
);
