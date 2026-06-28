import 'package:gate_buddy/features/notifications/data/remote/notifications_remote_ds.dart';
import 'package:gate_buddy/features/notifications/data/repo/notifications_repo.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsRemoteDs remoteDs;
  NotificationsRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getNotifications() => remoteDs.getNotifications();

  @override
  Future<dynamic> markAsRead(String id) => remoteDs.markAsRead(id);
}
