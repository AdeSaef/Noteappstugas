import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek/data/user.dart';
import 'package:projek/detail.dart';
import 'package:projek/register_page.dart';

class Result extends StatefulWidget {
  final int userId;

  Result({required this.userId});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.userId);
  }

  Future<User> fetchUser(int id) async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return User.fromJson(json['data']);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Hasil Find')),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            User user = snapshot.data!;
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Image.network(
                  user.avatar,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                title: Text('${user.firstName} ${user.lastName}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(user: user),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}
