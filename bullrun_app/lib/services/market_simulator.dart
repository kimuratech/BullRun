import 'dart:math';
import '../models/asset.dart';

enum MarketRegime { calm, normal, turbulent }

class MarketSimulator {
  final List<Asset> assets;
  MarketRegime regime;
  final Random _rng = Random();

  // Regime transition matrix (simplified)
  final Map<MarketRegime, List<double>> transitionMatrix = {
    MarketRegime.calm: [0.85, 0.13, 0.02],
    MarketRegime.normal: [0.10, 0.80, 0.10],
    MarketRegime.turbulent: [0.05, 0.20, 0.75],
  };

  MarketSimulator({required this.assets, this.regime = MarketRegime.normal});

  // Simulate regime switching
  void nextRegime() {
    final probs = transitionMatrix[regime]!;
    final roll = _rng.nextDouble();
    double acc = 0;
    for (int i = 0; i < probs.length; i++) {
      acc += probs[i];
      if (roll < acc) {
        regime = MarketRegime.values[i];
        break;
      }
    }
  }

  // Simulate price tick for each asset
  Map<String, double> nextPrices(Map<String, double> prevPrices) {
    nextRegime();
    final Map<String, double> newPrices = {};
    for (final asset in assets) {
      final prev = prevPrices[asset.id] ?? 100.0;
      final drift = asset.drift;
      final baseVol = asset.baseVol * _regimeVolMultiplier();
      final dt = 1.0 / 252.0; // daily step
      final shock = _rng.nextDouble() * 2 - 1; // [-1,1]
      final dz = shock * sqrt(dt);
      final price = prev *
          (1 + drift * dt + baseVol * dz + _eventJump(asset));
      newPrices[asset.id] = price;
    }
    return newPrices;
  }

  double _regimeVolMultiplier() {
    switch (regime) {
      case MarketRegime.calm:
        return 0.7;
      case MarketRegime.normal:
        return 1.0;
      case MarketRegime.turbulent:
        return 1.7;
    }
  }

  double _eventJump(Asset asset) {
    // Placeholder for event-driven jumps (e.g., CPI, news)
    if (_rng.nextDouble() < 0.03 && regime == MarketRegime.turbulent) {
      return _rng.nextDouble() * 0.05 - 0.025; // [-2.5%, +2.5%]
    }
    return 0.0;
  }
}
