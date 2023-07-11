import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserStatusPage extends StatelessWidget {
  const UserStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton.filled(child: const Text('seaker'), onPressed: () {}),
          CupertinoButton.filled(
              child: const Text('employer'), onPressed: () {}),
        ],
      ),
    );
  }
}
