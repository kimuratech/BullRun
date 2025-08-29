import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/simulation_provider.dart';
import '../models/asset.dart';
import '../models/portfolio.dart';
import '../models/session.dart';
import '../features/session_provider.dart';
import 'animated_value.dart';
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  Session? _lastSession;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final session = ref.read(sessionProvider);
    if (session != null && session != _lastSession) {
      ref.read(simulationProvider).start(session, isMounted: () => mounted);
      _lastSession = session;
    }
  }
  // Stub for transaction history widget
  Widget _buildTransactionHistory(List transactions) {
    return Card(
      color: Colors.white.withAlpha((0.85 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            if (transactions.isEmpty)
              const Text('No transactions yet.'),
            for (final tx in transactions)
              Text(tx.toString()),
          ],
        ),
      ),
    );
  }

  // Stub for trade dialog
  void _showTradeDialog(BuildContext context, List<Asset> assets, Portfolio portfolio) {
    showDialog(
      context: context,
      builder: (context) {
        final Map<Asset, double> tempAlloc = Map<Asset, double>.from(portfolio.allocations);
        return StatefulBuilder(
          builder: (context, setState) {
            double total = tempAlloc.values.fold(0.0, (a, b) => a + b);
            return AlertDialog(
              title: const Text('Trade'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...assets.map((asset) {
                    return Row(
                      children: [
                        Expanded(child: Text(asset.displayName)),
                        SizedBox(
                          width: 80,
                          child: Slider(
                            value: tempAlloc[asset] ?? 0.0,
                            min: 0.0,
                            max: 1.0,
                            divisions: 100,
                            label: '${((tempAlloc[asset] ?? 0.0) * 100).toStringAsFixed(0)}%',
                            onChanged: (v) {
                              setState(() {
                                tempAlloc[asset] = v;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('${((tempAlloc[asset] ?? 0.0) * 100).toStringAsFixed(0)}%'),
                      ],
                    );
                  }),
                  const SizedBox(height: 8),
                  Text('Total: ${(total * 100).toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.bold)),
                  if ((total - 1.0).abs() > 0.01)
                    const Text('Total must be 100%', style: TextStyle(color: Colors.red)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: (total - 1.0).abs() > 0.01
                      ? null
                      : () {
                          final newPortfolio = Portfolio(
                            allocations: Map<Asset, double>.from(tempAlloc),
                            value: portfolio.value,
                          );
                          ref.read(sessionProvider.notifier).state = ref.read(sessionProvider)!.copyWith(portfolio: newPortfolio);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trade submitted!')),
                          );
                        },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAnalyticsDialog(BuildContext context, List<Asset> assets, Map<String, double> prices, Portfolio portfolio) {
    // MVP: total return, best/worst asset, volatility (stddev of prices)
    final initialValue = 100.0;
    final totalReturn = ((portfolio.value - (initialValue * assets.length)) / (initialValue * assets.length)) * 100;
    Asset? best;
    Asset? worst;
    double bestPnl = double.negativeInfinity;
    double worstPnl = double.infinity;
    for (final asset in assets) {
      final price = prices[asset.id] ?? 100.0;
      final pnl = price - initialValue;
      if (pnl > bestPnl) {
        bestPnl = pnl;
        best = asset;
      }
      if (pnl < worstPnl) {
        worstPnl = pnl;
        worst = asset;
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Return: ${totalReturn.toStringAsFixed(2)}%'),
            if (best != null) Text('Best Asset: ${best.displayName}'),
            if (worst != null) Text('Worst Asset: ${worst.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final portfolio = session?.portfolio;
    final assets = session?.assets ?? [
      Asset(id: 'EQ_TECH', displayName: 'Tech ETF', baseVol: 0.2, drift: 0.0),
      Asset(id: 'BOND', displayName: 'Bond ETF', baseVol: 0.1, drift: 0.0),
    ];
    final prices = ref.watch(pricesProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('BullRun: Match'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ...existing code for header, animated value, transaction history, and main cards...
                // You can paste your working cards and action buttons here, making sure all widgets are inside this Column
                // For now, add a placeholder to ensure the tree is valid:
                // Portfolio Value header and analytics button
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Portfolio Value',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.analytics, color: Colors.deepPurple),
                      tooltip: 'Show Analytics',
                      onPressed: () {
                        if (portfolio != null && session != null) {
                          _showAnalyticsDialog(context, session.assets, prices, portfolio);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Analytics unavailable: no session loaded.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedValue(
                  value: portfolio?.value ?? 240,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  prefix: '\u0024',
                ),
                const SizedBox(height: 18),
                if (session != null) ...[
                  _buildTransactionHistory(session.transactions),
                  const SizedBox(height: 10),
                ] else ...[
                  _buildTransactionHistory([]),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prices Card
                      Expanded(
                        child: Card(
                          color: Colors.white.withAlpha((0.85 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.show_chart, color: Color(0xFF2c5364)),
                                    SizedBox(width: 8),
                                    Text('Prices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: assets.map((asset) {
                                    final price = prices[asset.id] ?? 100.0;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.circle, size: 12, color: Colors.blueGrey),
                                          const SizedBox(width: 8),
                                          Text(asset.displayName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 8),
                                          AnimatedValue(
                                            value: price,
                                            style: const TextStyle(color: Colors.grey),
                                            prefix: '\u0024',
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Portfolio Card
                      Expanded(
                        child: Card(
                          color: Colors.white.withAlpha((0.85 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.account_balance_wallet, color: Color(0xFF2c5364)),
                                    SizedBox(width: 8),
                                    Text('Portfolio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (portfolio != null && portfolio.allocations.isNotEmpty)
                                  Column(
                                    children: portfolio.allocations.entries.map((e) {
                                      final asset = e.key;
                                      final weight = e.value;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: InkWell(
                                          onTap: () {
                                            final price = prices[asset.id] ?? 100.0;
                                            final initialPrice = 100.0;
                                            final pnl = price - initialPrice;
                                            final pnlPct = (pnl / initialPrice) * 100;
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('${asset.displayName} P&L'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Current Price: ${price.toStringAsFixed(2)}'),
                                                    Text('Initial Price: ${initialPrice.toStringAsFixed(2)}'),
                                                    Text('P&L: '
                                                      '${pnl >= 0 ? '+' : ''}${pnl.toStringAsFixed(2)} '
                                                      '(${pnlPct >= 0 ? '+' : ''}${pnlPct.toStringAsFixed(2)}%)',
                                                      style: TextStyle(
                                                        color: pnl >= 0 ? Colors.green : Colors.red,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.circle, size: 12, color: Colors.teal),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 80,
                                                child: Text(asset.displayName, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                              ),
                                              const SizedBox(width: 8),
                                              Text('${(weight * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                else ...[
                                  const Text('No portfolio loaded.', style: TextStyle(color: Colors.grey)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Actions Card
                      Expanded(
                        child: Card(
                          color: Colors.white.withAlpha((0.85 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.flash_on, color: Color(0xFF2c5364)),
                                      SizedBox(width: 8),
                                      Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        final n = session.assets.length;
                                        final newAlloc = {for (var a in session.assets) a: 1.0 / n};
                                        final newPortfolio = Portfolio(
                                          allocations: newAlloc,
                                          value: session.portfolio.value,
                                        );
                                        ref.read(sessionProvider.notifier).state = session.copyWith(
                                          portfolio: newPortfolio,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Portfolio rebalanced to equal weights!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.sync_alt),
                                    label: const Text('Rebalance'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        _showTradeDialog(context, session.assets, session.portfolio);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.shopping_cart),
                                    label: const Text('Trade'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        final bond = session.assets.firstWhere((a) => a.id == 'BOND', orElse: () => session.assets.first);
                                        final alloc = Map<Asset, double>.from(session.portfolio.allocations);
                                        final totalOther = alloc.entries.where((e) => e.key != bond).fold(0.0, (sum, e) => sum + e.value);
                                        alloc[bond] = 0.2;
                                        for (var a in alloc.keys) {
                                          if (a != bond) alloc[a] = alloc[a]! * 0.8 / totalOther;
                                        }
                                        final newPortfolio = Portfolio(
                                          allocations: alloc,
                                          value: session.portfolio.value,
                                        );
                                        ref.read(sessionProvider.notifier).state = session.copyWith(portfolio: newPortfolio);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('20% allocated to Bond for tail hedge!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.shield),
                                    label: const Text('Tail Hedge'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        final tech = session.assets.firstWhere((a) => a.id == 'EQ_TECH', orElse: () => session.assets.first);
                                        final alloc = Map<Asset, double>.from(session.portfolio.allocations);
                                        final totalOther = alloc.entries.where((e) => e.key != tech).fold(0.0, (sum, e) => sum + e.value);
                                        alloc[tech] = 0.4;
                                        for (var a in alloc.keys) {
                                          if (a != tech) alloc[a] = alloc[a]! * 0.6 / totalOther;
                                        }
                                        final newPortfolio = Portfolio(
                                          allocations: alloc,
                                          value: session.portfolio.value,
                                        );
                                        ref.read(sessionProvider.notifier).state = session.copyWith(portfolio: newPortfolio);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('40% allocated to Tech ETF for sector tilt!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.trending_up),
                                    label: const Text('Sector Tilt'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        final bond = session.assets.firstWhere((a) => a.id == 'BOND', orElse: () => session.assets.first);
                                        final alloc = {for (var a in session.assets) a: a == bond ? 1.0 : 0.0};
                                        final newPortfolio = Portfolio(
                                          allocations: alloc,
                                          value: session.portfolio.value,
                                        );
                                        ref.read(sessionProvider.notifier).state = session.copyWith(portfolio: newPortfolio);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('All assets sold, 100% in Bond (Stop-loss)!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.warning),
                                    label: const Text('Stop-loss All'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (session != null && portfolio != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Draft submitted! (No effect in MVP)')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No session loaded.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.send),
                                    label: const Text('Submit Draft'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  color: Colors.white.withAlpha((0.9 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Row(
                      children: [
                        Icon(Icons.show_chart, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text('Chart: Portfolio Value', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 32),
                        Icon(Icons.event, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text('Events Feed: CPI +', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}