import 'package:hive/hive.dart';
import '../models/subscription.dart';

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 0;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      amount: fields[3] as double,
      currency: fields[4] as String? ?? 'USD',
      billingCycle: fields[5] as String,
      startDate: fields[6] as DateTime,
      nextBillingDate: fields[7] as DateTime?,
      reminderDate: fields[8] as DateTime?,
      category: fields[9] as String,
      iconUrl: fields[10] as String?,
      status: fields[11] as String? ?? 'active',
      isTrial: fields[12] as bool? ?? false,
      trialEndDate: fields[13] as DateTime?,
      reminderDays: (fields[14] as List?)?.cast<String>() ?? ['7', '3', '1'],
      notificationsEnabled: fields[15] as bool? ?? true,
      website: fields[16] as String?,
      cancelUrl: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.description)
      ..writeByte(3)..write(obj.amount)
      ..writeByte(4)..write(obj.currency)
      ..writeByte(5)..write(obj.billingCycle)
      ..writeByte(6)..write(obj.startDate)
      ..writeByte(7)..write(obj.nextBillingDate)
      ..writeByte(8)..write(obj.reminderDate)
      ..writeByte(9)..write(obj.category)
      ..writeByte(10)..write(obj.iconUrl)
      ..writeByte(11)..write(obj.status)
      ..writeByte(12)..write(obj.isTrial)
      ..writeByte(13)..write(obj.trialEndDate)
      ..writeByte(14)..write(obj.reminderDays)
      ..writeByte(15)..write(obj.notificationsEnabled)
      ..writeByte(16)..write(obj.website)
      ..writeByte(17)..write(obj.cancelUrl);
  }
}