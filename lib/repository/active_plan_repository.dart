import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workout_app/models/active_plan.dart';
import 'package:workout_app/models/plan_definition.dart';

class ActivePlanRepository {
  final Box box;

  String activePlanKey = 'active_plan_box';

  ActivePlanRepository(this.box);

  ActivePlan? getActivePlan() {
    final data = box.get(activePlanKey);
    if (data == null) return null;
    return ActivePlan.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> startPlan(PlanDefinition plan) async {
    final active = ActivePlan(
      planId: plan.id,
      planName: plan.name,
      startDate: DateTime.now(),
      totalDays: plan.totalDays,
      currentDay: 1,
      streak: 0,
    );
    await box.put(activePlanKey, active.toMap());
  }

  Future<void> completeDay() async {
    final active = getActivePlan();

    if (active == null) return;
    await box.put(
      activePlanKey,
      active
          .copyWith(
            currentDay: active.currentDay + 1,
            streak: active.streak + 1,
          )
          .toMap(),
    );
  }

  Future<void> clear() async {
    await box.delete(activePlanKey);
  }
}
