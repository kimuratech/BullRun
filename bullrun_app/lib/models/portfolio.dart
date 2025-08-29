import 'asset.dart';

class Portfolio {
  final Map<Asset, double> allocations; // Asset to weight (0-1)
  double value;

  Portfolio({
    required this.allocations,
    required this.value,
  });
}
