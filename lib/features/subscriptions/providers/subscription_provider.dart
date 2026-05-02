import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/subscription.dart';
import '../data/subscription_presets.dart';
import '../../../core/services/storage_service.dart';

class SubscriptionNotifier extends StateNotifier<List<Subscription>> {
  SubscriptionNotifier() : super([]) {
    _loadSubscriptions();
  }

  final _uuid = const Uuid();

  void _loadSubscriptions() {
    final box = StorageService.getSubscriptions();
    state = box.values.toList();
  }

  Future<void> addSubscription(Subscription subscription) async {
    final box = StorageService.getSubscriptions();
    await box.put(subscription.id, subscription);
    state = [...state, subscription];
    
    if (subscription.notificationsEnabled) {
      await _scheduleReminders(subscription);
    }
  }

  Future<void> updateSubscription(Subscription subscription) async {
    final box = StorageService.getSubscriptions();
    await box.put(subscription.id, subscription);
    state = state.map((s) => s.id == subscription.id ? subscription : s).toList();
  }

  Future<void> deleteSubscription(String id) async {
    final box = StorageService.getSubscriptions();
    await box.delete(id);
    state = state.where((s) => s.id != id).toList();
  }

  Future<void> toggleActive(String id) async {
    final sub = state.firstWhere((s) => s.id == id);
    final updated = sub.copyWith(status: sub.status == 'active' ? 'paused' : 'active');
    await updateSubscription(updated);
  }

  List<Subscription> getByCategory(String category) {
    return state.where((s) => s.category == category && s.status == 'active').toList();
  }

  List<Subscription> get activeSubscriptions {
    return state.where((s) => s.status == 'active').toList();
  }

  double get totalMonthly {
    return activeSubscriptions.fold(0.0, (sum, s) => sum + s.monthlyEquivalent);
  }

  double get totalYearly {
    return activeSubscriptions.fold(0.0, (sum, s) => sum + s.yearlyEquivalent);
  }

  List<Subscription> get upcomingPayments {
    final now = DateTime.now();
    final in30Days = now.add(const Duration(days: 30));
    return activeSubscriptions.where((s) {
      final nextDate = s.nextBillingDate ?? s.startDate.add(const Duration(days: 30));
      return nextDate.isAfter(now) && nextDate.isBefore(in30Days);
    }).toList()
      ..sort((a, b) => (a.nextBillingDate ?? a.startDate).compareTo(b.nextBillingDate ?? b.startDate));
  }

  List<Map<String, dynamic>> searchPresets(String query) {
    return SubscriptionPresets.search(query);
  }

  List<Map<String, dynamic>> getPresetsByCategory(String category) {
    return SubscriptionPresets.byCategory(category);
  }

  List<Map<String, dynamic>> get allPresets => SubscriptionPresets.allPresets;

  Future<void> _scheduleReminders(Subscription subscription) async {
    // Schedule notification reminders
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, List<Subscription>>((ref) {
  return SubscriptionNotifier();
});