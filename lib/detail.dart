import 'package:flutter/material.dart';
import 'package:projek/data/user.dart';


class DetailPage extends StatelessWidget {
  final User user;

  const DetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(user.avatar, width: 100, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text('ID: ${user.id}'),
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}
