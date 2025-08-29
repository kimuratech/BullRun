import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';

import '../models/asset.dart';
import '../models/portfolio.dart';

final sessionProvider = StateProvider<Session?>((ref) {
	// Demo assets
	final assets = [
		Asset(id: 'EQ_TECH', displayName: 'Tech ETF', baseVol: 0.2, drift: 0.08),
		Asset(id: 'BOND', displayName: 'Bond ETF', baseVol: 0.1, drift: 0.02),
	];
	// Demo portfolio: 50/50
	final portfolio = Portfolio(
		allocations: {for (var a in assets) a: 0.5},
		value: 200.0,
	);
	return Session(
		id: 'demo',
		mode: SessionMode.practice,
		assets: assets,
		portfolio: portfolio,
		startedAt: DateTime.now(),
		durationSeconds: 600,
	);
});
