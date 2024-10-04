import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo'),
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            'Bác sĩ của bạn đã xác nhận cuộc hẹn!',
            'Hẹn gặp vào lúc 14:00, 15/10/2024',
          ),
          _buildNotificationItem(
            'Bạn có một cuộc hẹn mới!',
            'Bác sĩ A đã đặt lịch với bạn vào lúc 10:00, 20/10/2024',
          ),
          _buildNotificationItem(
            'Nhắc nhở: Cuộc hẹn của bạn sắp đến!',
            'Cuộc hẹn vào lúc 15:00, 22/10/2024',
          ),
          // Thêm nhiều thông báo khác nếu cần
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: const Icon(Icons.notifications),
        onTap: () {
          // Thêm hành động khi nhấn vào thông báo
        },
      ),
    );
  }
}
