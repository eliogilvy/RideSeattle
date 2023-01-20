import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/home.dart';
import 'classes/state_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var stateInfo = StateInfo();
  await stateInfo.getAgencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stateInfo),
      ],
      child: const Home(),
    ),
  );
}
