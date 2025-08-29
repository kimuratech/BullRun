import 'asset.dart';

class Transaction {
  final DateTime timestamp;
  final Asset asset;
  final double percent;
  final String type; // 'buy' or 'sell'

  Transaction({
    required this.timestamp,
    required this.asset,
    required this.percent,
    required this.type,
  });
}
