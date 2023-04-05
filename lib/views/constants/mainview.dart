import 'package:flutter/material.dart';
import 'package:hospital/Services/Auth/auth_service.dart';
import 'package:hospital/Services/CRUD/message_services.dart';
import 'package:hospital/views/constants/routes.dart';

import '../../enum/menu_actions.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  late final MessageService _messageService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    _messageService = MessageService();

    super.initState();
  }

  @override
  void dispose() {
    _messageService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCrate'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  if (shouldlogout) {
                    await AuthService.firebase().logout();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }

                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _messageService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return const Text("Your Message will appear Here");
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text('Are you sure you want to Logout'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Logout"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("cancel"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
