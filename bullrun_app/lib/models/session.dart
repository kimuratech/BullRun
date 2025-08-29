import 'asset.dart';

import 'portfolio.dart';
import 'transaction.dart';

enum SessionMode { blitz, daily, practice }

class Session {
  final String id;
  final SessionMode mode;
  final List<Asset> assets;
  final Portfolio portfolio;
  final DateTime startedAt;
  final int durationSeconds;
  final List<Transaction> transactions;

  Session({
    required this.id,
    required this.mode,
    required this.assets,
    required this.portfolio,
    required this.startedAt,
    required this.durationSeconds,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  Session copyWith({
    String? id,
    SessionMode? mode,
    List<Asset>? assets,
    Portfolio? portfolio,
    DateTime? startedAt,
    int? durationSeconds,
    List<Transaction>? transactions,
  }) {
    return Session(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      assets: assets ?? this.assets,
      portfolio: portfolio ?? this.portfolio,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      transactions: transactions ?? this.transactions,
    );
  }
}
