import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../../../core/services/storage_service.dart';

class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier() : super(SettingsModel()) {
    _loadSettings();
  }

  void _loadSettings() {
    final box = StorageService.getSettings();
    if (box.isNotEmpty) {
      state = box.getAt(0) ?? SettingsModel();
    }
  }

  Future<void> toggleDarkMode() async {
    state = SettingsModel(
      isDarkMode: !state.isDarkMode,
      currency: state.currency,
      notificationsEnabled: state.notificationsEnabled,
      trialRemindersEnabled: state.trialRemindersEnabled,
      reminderDays: state.reminderDays,
      soundEnabled: state.soundEnabled,
      vibrationEnabled: state.vibrationEnabled,
      language: state.language,
    );
    await _saveSettings();
  }

  Future<void> setCurrency(String currency) async {
    state = SettingsModel(
      isDarkMode: state.isDarkMode,
      currency: currency,
      notificationsEnabled: state.notificationsEnabled,
      trialRemindersEnabled: state.trialRemindersEnabled,
      reminderDays: state.reminderDays,
      soundEnabled: state.soundEnabled,
      vibrationEnabled: state.vibrationEnabled,
      language: state.language,
    );
    await _saveSettings();
  }

  Future<void> toggleNotifications() async {
    state = SettingsModel(
      isDarkMode: state.isDarkMode,
      currency: state.currency,
      notificationsEnabled: !state.notificationsEnabled,
      trialRemindersEnabled: state.trialRemindersEnabled,
      reminderDays: state.reminderDays,
      soundEnabled: state.soundEnabled,
      vibrationEnabled: state.vibrationEnabled,
      language: state.language,
    );
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    final box = StorageService.getSettings();
    await box.putAt(0, state);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  return SettingsNotifier();
});