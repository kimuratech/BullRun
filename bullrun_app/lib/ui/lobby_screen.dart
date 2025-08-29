
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: const Text(
          '1. Tap a mode to start a match.\n'
          '2. Watch your portfolio value change as the market simulates.\n'
          '3. (Coming soon) Use action buttons to rebalance or hedge.\n'
          '4. Try to maximize your risk-adjusted return!\n\n'
          'This is an MVP demo. More features coming soon.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('BullRun'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose Your Mode',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ModeCard(
                      icon: FontAwesomeIcons.bolt,
                      label: 'Blitz 10m',
                      color: Colors.orangeAccent,
                      onTap: () => Navigator.pushNamed(context, '/match'),
                    ),
                    const SizedBox(width: 16),
                    _ModeCard(
                      icon: FontAwesomeIcons.trophy,
                      label: 'Daily',
                      color: Colors.amber,
                      onTap: () => Navigator.pushNamed(context, '/match'),
                    ),
                    const SizedBox(width: 16),
                    _ModeCard(
                      icon: FontAwesomeIcons.userGraduate,
                      label: 'Practice',
                      color: Colors.lightBlueAccent,
                      onTap: () => Navigator.pushNamed(context, '/match'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 32),
                  label: const Text('Start'),
                  onPressed: () => Navigator.pushNamed(context, '/match'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showHowToPlay(context),
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      label: const Text('How it works', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/results'),
                      icon: const Icon(Icons.emoji_events, color: Colors.amber),
                      label: const Text('Season Rewards', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ModeCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 110,
        decoration: BoxDecoration(
          color: color.withAlpha((0.9 * 255).toInt()),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.3 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
