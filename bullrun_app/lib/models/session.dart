import 'asset.dart';
import 'portfolio.dart';

enum SessionMode { blitz, daily, practice }

class Session {
  final String id;
  final SessionMode mode;
  final List<Asset> assets;
  final Portfolio portfolio;
  final DateTime startedAt;
  final int durationSeconds;

  Session({
    required this.id,
    required this.mode,
    required this.assets,
    required this.portfolio,
    required this.startedAt,
    required this.durationSeconds,
  });
}
