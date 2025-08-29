import 'asset.dart';

class Portfolio {
  final Map<Asset, double> allocations; // Asset to weight (0-1)
  final double value;

  Portfolio({
    required this.allocations,
    required this.value,
  });

  Portfolio copyWith({
    Map<Asset, double>? allocations,
    double? value,
  }) {
    return Portfolio(
      allocations: allocations ?? this.allocations,
      value: value ?? this.value,
    );
  }
}
