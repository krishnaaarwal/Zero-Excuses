// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_nutrition_goals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyNutritionGoalsAdapter extends TypeAdapter<DailyNutritionGoals> {
  @override
  final typeId = 3;

  @override
  DailyNutritionGoals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyNutritionGoals(
      caloriesTarget: (fields[0] as num).toInt(),
      proteinTarget: (fields[1] as num).toInt(),
      carbsTarget: (fields[2] as num).toInt(),
      fatsTarget: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyNutritionGoals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.caloriesTarget)
      ..writeByte(1)
      ..write(obj.proteinTarget)
      ..writeByte(2)
      ..write(obj.carbsTarget)
      ..writeByte(3)
      ..write(obj.fatsTarget);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyNutritionGoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
