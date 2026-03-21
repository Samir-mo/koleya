import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/notifications_cubit.dart';
import '../../cubit/notifications_state.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..getNotifications(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF0285B8),
          centerTitle: true,
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationsError) {
              return Center(
                  child: Text("❌ ${state.message}",
                      style: const TextStyle(color: Colors.red)));
            }

            if (state is NotificationsLoaded) {
              final notifs = state.notifications;
              if (notifs.isEmpty) {
                return const Center(
                  child: Text(
                    "No notifications yet 📭",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const Divider(height: 20),
                itemCount: notifs.length,
                itemBuilder: (context, i) =>
                    NotificationTile(notification: notifs[i]),
              );
            }

            return const Center(child: Text("Loading notifications..."));
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_active, color: Color(0xFF0285B8)),
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        notification.body,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: Text(
        notification.createdAt ?? '',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}