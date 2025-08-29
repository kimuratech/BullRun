import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Final Value: \$10,000'),
            const Text('Sharpe-like: 1.00'),
            const Text('Vol: 10.0%  Max DD: -5.0%'),
            const Text('Bonuses: Diversification +0.1, Hedge +0.05'),
            const Text('Leaderboard: #--/---'),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Share'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Rematch'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Analyze Run'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
