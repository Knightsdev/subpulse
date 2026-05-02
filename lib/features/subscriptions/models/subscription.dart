import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String currency;

  @HiveField(5)
  String billingCycle;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime? nextBillingDate;

  @HiveField(8)
  DateTime? reminderDate;

  @HiveField(9)
  String category;

  @HiveField(10)
  String? iconUrl;

  @HiveField(11)
  String status;

  @HiveField(12)
  bool isTrial;

  @HiveField(13)
  DateTime? trialEndDate;

  @HiveField(14)
  List<String> reminderDays;

  @HiveField(15)
  bool notificationsEnabled;

  @HiveField(16)
  String? website;

  @HiveField(17)
  String? cancelUrl;

  Subscription({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    this.currency = 'USD',
    required this.billingCycle,
    required this.startDate,
    this.nextBillingDate,
    this.reminderDate,
    required this.category,
    this.iconUrl,
    this.status = 'active',
    this.isTrial = false,
    this.trialEndDate,
    List<String>? reminderDays,
    this.notificationsEnabled = true,
    this.website,
    this.cancelUrl,
  }) : reminderDays = reminderDays ?? ['7', '3', '1'];

  Subscription copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
    String? currency,
    String? billingCycle,
    DateTime? startDate,
    DateTime? nextBillingDate,
    DateTime? reminderDate,
    String? category,
    String? iconUrl,
    String? status,
    bool? isTrial,
    DateTime? trialEndDate,
    List<String>? reminderDays,
    bool? notificationsEnabled,
    String? website,
    String? cancelUrl,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      reminderDate: reminderDate ?? this.reminderDate,
      category: category ?? this.category,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      isTrial: isTrial ?? this.isTrial,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      reminderDays: reminderDays ?? this.reminderDays,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      website: website ?? this.website,
      cancelUrl: cancelUrl ?? this.cancelUrl,
    );
  }

  double get monthlyEquivalent {
    switch (billingCycle) {
      case 'weekly': return amount * 4.33;
      case 'monthly': return amount;
      case 'quarterly': return amount / 3;
      case 'semi-annual': return amount / 6;
      case 'yearly': return amount / 12;
      default: return amount;
    }
  }

  double get yearlyEquivalent {
    switch (billingCycle) {
      case 'weekly': return amount * 52;
      case 'monthly': return amount * 12;
      case 'quarterly': return amount * 4;
      case 'semi-annual': return amount * 2;
      case 'yearly': return amount;
      default: return amount;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'currency': currency,
      'billingCycle': billingCycle,
      'startDate': startDate.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'category': category,
      'iconUrl': iconUrl,
      'status': status,
      'isTrial': isTrial,
      'trialEndDate': trialEndDate?.toIso8601String(),
      'reminderDays': reminderDays,
      'notificationsEnabled': notificationsEnabled,
      'website': website,
      'cancelUrl': cancelUrl,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      billingCycle: json['billingCycle'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      nextBillingDate: json['nextBillingDate'] != null ? DateTime.parse(json['nextBillingDate'] as String) : null,
      reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate'] as String) : null,
      category: json['category'] as String,
      iconUrl: json['iconUrl'] as String?,
      status: json['status'] as String? ?? 'active',
      isTrial: json['isTrial'] as bool? ?? false,
      trialEndDate: json['trialEndDate'] != null ? DateTime.parse(json['trialEndDate'] as String) : null,
      reminderDays: (json['reminderDays'] as List?)?.cast<String>() ?? ['7', '3', '1'],
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      website: json['website'] as String?,
      cancelUrl: json['cancelUrl'] as String?,
    );
  }
}