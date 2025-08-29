
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';
// import '../models/asset.dart';
import '../models/portfolio.dart';
import '../services/market_simulator.dart';
import 'session_provider.dart';

// Provider to expose current prices for UI
final pricesProvider = Provider.autoDispose<Map<String, double>>((ref) {
  final sim = ref.watch(simulationProvider);
  return sim.prices;
});

final simulationProvider = Provider.autoDispose<SimulationController>((ref) {
  return SimulationController(ref);
});

class SimulationController {
  Map<String, double> get prices => _prices;
  final Ref ref;
  Timer? _timer;
  late MarketSimulator _simulator;
  Map<String, double> _prices = {};
  bool Function()? _isMounted;

  SimulationController(this.ref);

  void start(Session session, {bool Function()? isMounted}) {
    _simulator = MarketSimulator(assets: session.assets);
    _prices = {for (var a in session.assets) a.id: 100.0};
    _isMounted = isMounted;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
  }

  void _tick() {
    if (_isMounted == null || !_isMounted!()) {
      _timer?.cancel();
      return;
    }
    try {
      final session = ref.read(sessionProvider)!;
      _prices = _simulator.nextPrices(_prices);
      // Update portfolio value (simple sum for now)
      double value = 0;
      session.portfolio.allocations.forEach((asset, weight) {
        value += weight * (_prices[asset.id] ?? 100.0);
      });
      final updatedPortfolio = Portfolio(
        allocations: session.portfolio.allocations,
        value: value,
      );
      final updatedSession = session.copyWith(portfolio: updatedPortfolio);
      ref.read(sessionProvider.notifier).state = updatedSession;
    } catch (e) {
      _timer?.cancel();
    }
  }
}
