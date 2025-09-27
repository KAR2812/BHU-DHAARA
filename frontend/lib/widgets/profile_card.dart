import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  ProfileCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name.isNotEmpty ? name[0] : 'U')),
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }
}
