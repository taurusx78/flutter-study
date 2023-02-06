import 'package:flutter/material.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/screen/state_notifier_provider_screen.dart';
import 'package:riverpod_practice/screen/state_provider_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Home Screen',
      body: ListView(
        children: [
          ElevatedButton(
            child: const Text('State Provider'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StateProviderScreen(),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('State Notifier Provider'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StateNotifierProviderScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
