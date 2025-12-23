class ActivePlan {
  final String planId;
  final String planName;
  final DateTime startDate;
  final int currentDay;
  final int totalDays;
  final int streak;

  const ActivePlan({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.currentDay,
    required this.totalDays,
    required this.streak,
  });

  ActivePlan copyWith({int? currentDay, int? streak}) {
    return ActivePlan(
      planId: planId,
      planName: planName,
      startDate: startDate,
      currentDay: currentDay ?? this.currentDay,
      totalDays: totalDays,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toMap() => {
    'planId': planId,
    'planName': planName,
    'startDate': startDate.toIso8601String(),
    'currentDay': currentDay,
    'totalDays': totalDays,
    'streak': streak,
  };

  factory ActivePlan.fromMap(Map<String, dynamic> map) {
    return ActivePlan(
      planId: map['planId'],
      planName: map['planName'],
      startDate: DateTime.parse(map['startDate']),
      currentDay: map['currentDay'],
      totalDays: map['totalDays'],
      streak: map['streak'],
    );
  }
}
