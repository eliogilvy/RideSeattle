import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ride_seattle/Pages/current_location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gmap"),
        centerTitle: true,
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Beamer.of(context).beamToNamed('/map');
                  },
                  child: const Text("User current location"))
            ],
          )),
    );
  }
}
