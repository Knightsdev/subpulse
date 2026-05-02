import 'package:hive_flutter/hive_flutter.dart';
import '../../features/subscriptions/models/subscription.dart';
import '../../features/settings/models/settings_model.dart';

class StorageService {
  static const String subscriptionBox = 'subscriptions';
  static const String settingsBox = 'settings';
  static const String emailBox = 'email_accounts';
  
  static Future<void> init() async {
    await Hive.openBox<Subscription>(subscriptionBox);
    await Hive.openBox<SettingsModel>(settingsBox);
    await Hive.openBox(emailBox);
  }
  
  static Box<Subscription> getSubscriptions() {
    return Hive.box<Subscription>(subscriptionBox);
  }
  
  static Box<SettingsModel> getSettings() {
    return Hive.box<SettingsModel>(settingsBox);
  }
  
  static Box getEmailAccounts() {
    return Hive.box(emailBox);
  }
  
  static Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(subscriptionBox);
    await Hive.deleteBoxFromDisk(settingsBox);
    await Hive.deleteBoxFromDisk(emailBox);
  }
}