import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/state_info.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateInfo>(
      builder: (context, stateInfo, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Hello"),
          ),
        );
      },
    );
  }
}
