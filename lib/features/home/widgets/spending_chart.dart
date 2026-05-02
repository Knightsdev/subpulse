import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../subscriptions/providers/subscription_provider.dart';
import '../../subscriptions/data/subscription_presets.dart';

class SpendingChart extends ConsumerWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptions = ref.watch(subscriptionProvider);
    final categories = SubscriptionPresets.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending by Category',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: subscriptions.isEmpty
              ? const Center(child: Text('No subscriptions yet'))
              : PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildSections(subscriptions, categories),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        _buildLegend(subscriptions, categories),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(List subscriptions, List<String> categories) {
    final List<PieChartSectionData> sections = [];
    final colors = [
      AppColors.primary,
      AppColors.accent,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];

    int colorIndex = 0;
    for (final category in categories) {
      final total = subscriptions
          .where((s) => s.category == category && s.status == 'active')
          .fold(0.0, (sum, s) => sum + s.monthlyEquivalent);

      if (total > 0) {
        sections.add(PieChartSectionData(
          value: total,
          title: '',
          color: colors[colorIndex % colors.length],
          radius: 60,
        ));
      }
      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend(List subscriptions, List<String> categories) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(categories.length, (index) {
        final category = categories[index];
        final total = subscriptions
            .where((s) => s.category == category && s.status == 'active')
            .fold(0.0, (sum, s) => sum + s.monthlyEquivalent);

        if (total <= 0) return const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              category,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }
}