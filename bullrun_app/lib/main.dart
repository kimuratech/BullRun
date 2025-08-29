

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/lobby_screen.dart';
import 'ui/match_screen.dart';
import 'ui/results_screen.dart';

void main() {
  runApp(const ProviderScope(child: BullRunApp()));
}

class BullRunApp extends StatelessWidget {
  const BullRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BullRun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LobbyScreen(),
        '/match': (context) => const MatchScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}
