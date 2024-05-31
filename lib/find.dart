import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result.dart';

class FindUser extends StatefulWidget {
  const FindUser({super.key});

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  final TextEditingController _inputIdController = TextEditingController();

  Future<void> _findUser() async {
    final String id = _inputIdController.text;

    if (id.isNotEmpty) {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users/$id'),
      );

      // Print the response to the debug console
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User found: ${responseData['data']['first_name']} ${responseData['data']['last_name']}')),
        );
        print('Response body: ${response.body}');

        // Navigate to Result page with the user ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Result(userId: int.parse(id)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to find user')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Find User by ID',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _inputIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ID",
                  hintText: "Enter ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _findUser,
                  child: Text("Find"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
