import 'package:flutter/material.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/screen/auto_dispose_modifier_screen.dart';
import 'package:riverpod_practice/screen/family_modifier_screen.dart';
import 'package:riverpod_practice/screen/state_notifier_provider_screen.dart';
import 'package:riverpod_practice/screen/state_provider_screen.dart';
import 'package:riverpod_practice/screen/stream_provider_screen.dart';

import 'future_provider_screen.dart';

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
          ),
          ElevatedButton(
            child: const Text('Future Provider'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FutureProviderScreen(),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Stream Provider'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StreamProviderScreen(),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Family Modifier'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FamilyModifierScreen(),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Auto Dispose Modifier'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AutoDisposeModifierScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
