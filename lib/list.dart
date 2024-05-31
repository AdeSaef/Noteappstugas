import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek/data/user.dart';
import 'package:projek/detail.dart';
import 'package:projek/register_page.dart';
import 'package:projek/find.dart';

class ListUser extends StatefulWidget {
  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  late Future<List<User>> futureUsers;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(currentPage);
  }

  Future<List<User>> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> data = json['data'];

      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      futureUsers = fetchUsers(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Daftar Pengguna')), backgroundColor : Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                        ? Center(child: Text('Error: ${snapshot.error}'))
                        : !snapshot.hasData
                            ? Center(child: Text('No data found'))
                            : ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  User user = snapshot.data![index];
                                  return Card(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      leading: Image.network(
                                        user.avatar,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                          '${user.firstName} ${user.lastName}'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(user: user),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
                child: Text('Register'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindUser(),
                    ),
                  );
                },
                child: Text('Find'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed:
                    currentPage > 1 ? () => _changePage(currentPage - 1) : null,
                child: Text('previous'),
              ),
              ElevatedButton(
                onPressed:
                    currentPage < 2 ? () => _changePage(currentPage + 1) : null,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
