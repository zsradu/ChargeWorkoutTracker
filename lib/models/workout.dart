class Workout {
  final int? id;
  final DateTime date;
  final int exerciseId;
  final int sets;
  final int reps;
  final double weight;

  Workout({
    this.id,
    required this.date,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      exerciseId: map['exercise_id'] as int,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      weight: map['weight'] as double,
    );
  }

  Workout copyWith({
    int? id,
    DateTime? date,
    int? exerciseId,
    int? sets,
    int? reps,
    double? weight,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
    );
  }
} 