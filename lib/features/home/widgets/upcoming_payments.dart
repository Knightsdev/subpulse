import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../subscriptions/providers/subscription_provider.dart';
import 'subscription_card.dart';

class UpcomingPayments extends ConsumerWidget {
  const UpcomingPayments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(subscriptionProvider.notifier).upcomingPayments;

    if (upcoming.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: AppColors.success),
            SizedBox(height: 12),
            Text(
              'No upcoming payments',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'All caught up!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: upcoming.take(3).map((subscription) {
        final nextDate = subscription.nextBillingDate ?? subscription.startDate;
        final daysUntil = nextDate.difference(DateTime.now()).inDays;
        final dateFormat = DateFormat('MMM d, yyyy');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: daysUntil <= 3 
                ? AppColors.error.withOpacity(0.1) 
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: daysUntil <= 3 
                  ? AppColors.error.withOpacity(0.3) 
                  : AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: daysUntil <= 3 ? AppColors.error : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$daysUntil',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      daysUntil == 0 
                          ? 'Due today' 
                          : daysUntil == 1 
                              ? 'Due tomorrow' 
                              : 'Due ${dateFormat.format(nextDate)}',
                      style: TextStyle(
                        color: daysUntil <= 3 ? AppColors.error : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${subscription.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '/${subscription.billingCycle}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}