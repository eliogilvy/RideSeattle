import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/home.dart';
import 'classes/state_info.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => StateInfo(),
          ),
        ],
        child: const Home(),
      ),
    );
