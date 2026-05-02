import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String currency;

  @HiveField(2)
  bool notificationsEnabled;

  @HiveField(3)
  bool trialRemindersEnabled;

  @HiveField(4)
  List<String> reminderDays;

  @HiveField(5)
  bool soundEnabled;

  @HiveField(6)
  bool vibrationEnabled;

  @HiveField(7)
  String? language;

  SettingsModel({
    this.isDarkMode = false,
    this.currency = 'USD',
    this.notificationsEnabled = true,
    this.trialRemindersEnabled = true,
    List<String>? reminderDays,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.language,
  }) : reminderDays = reminderDays ?? ['7', '3', '1'];
}