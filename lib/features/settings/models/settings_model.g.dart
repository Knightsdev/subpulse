import 'package:hive/hive.dart';
import '../models/settings_model.dart';

class SettingsAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      isDarkMode: fields[0] as bool? ?? false,
      currency: fields[1] as String? ?? 'USD',
      notificationsEnabled: fields[2] as bool? ?? true,
      trialRemindersEnabled: fields[3] as bool? ?? true,
      reminderDays: (fields[4] as List?)?.cast<String>() ?? ['7', '3', '1'],
      soundEnabled: fields[5] as bool? ?? true,
      vibrationEnabled: fields[6] as bool? ?? true,
      language: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)..write(obj.isDarkMode)
      ..writeByte(1)..write(obj.currency)
      ..writeByte(2)..write(obj.notificationsEnabled)
      ..writeByte(3)..write(obj.trialRemindersEnabled)
      ..writeByte(4)..write(obj.reminderDays)
      ..writeByte(5)..write(obj.soundEnabled)
      ..writeByte(6)..write(obj.vibrationEnabled)
      ..writeByte(7)..write(obj.language);
  }
}