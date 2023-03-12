import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  final int timeout = 10;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: timeout)).then((value) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator(
          key: ValueKey("loader"),
        )
        : const Text("No data available, try tapping on the stop again.");
  }
}
