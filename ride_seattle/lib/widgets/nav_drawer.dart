import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../classes/auth.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildHeader(context),
        buildMenuItems(context),
      ],
    ));
  }
}

Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ));

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          //Home
          InkWell(
            child: ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                context.pop();
              },
            ),
          ),

          //My Routes
          InkWell(
            child: ListTile(
              leading: const Icon(Icons.star),
              title: const Text('My Routes'),
              onTap: () {
                context.push('/favoriteRoutes');
              },
            ),
          ),
          //History
          InkWell(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                context.pop();
              },
            ),
          ),
          const Divider(color: Colors.black),

          //Settings
          InkWell(
            child: ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Settings'),
              onTap: () {
                context.pop();
              },
            ),
          ),

          InkWell(
            child: ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Sign out'),
              onTap: () async {
                await Auth().signOut();
              },
            ),
          )
        ],
      ),
    );
