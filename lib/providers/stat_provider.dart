import 'package:flutter_money_management_app/helpers/db_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<Map<String, double>> {
  @override
  Future<Map<String, double>> build() async {
    final states = await getStatistics();
    return states;
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, Map<String, double>>(
  StatsNotifier.new,
);
