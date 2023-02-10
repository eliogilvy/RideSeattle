import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class navDrawer extends StatefulWidget {
  const navDrawer({Key? key}) : super(key: key);

  @override
  State<navDrawer> createState() => _navDrawerState();
}

class _navDrawerState extends State<navDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:<Widget> [
            buildHeader(context),
            buildMenuItems(context),
          ],
        )
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top:MediaQuery.of(context).padding.top,
    )
);

Widget buildMenuItems(BuildContext context) => Container (
  padding: const EdgeInsets.all(24),
  child: Wrap(
    runSpacing: 16,
    children: [
      //Home
      InkWell(
        child: ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: (){
            context.push('/');
          },
        ),
      ),

      //My Routes
      InkWell(
        child: ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('My Routes'),
          onTap: (){
            context.push('/');
          },
        ),
      ),
      //History
      InkWell(
        child: ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('History'),
          onTap: (){
            context.push('/');
          },
        ),
      ),
      const Divider(color: Colors.black),

      //Settings
      InkWell(
        child: ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Settings'),
          onTap: (){
            context.push('/');
          },
        ),
      )


    ],
  ),
);