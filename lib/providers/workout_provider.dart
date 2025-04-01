import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import 'database_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final workoutsByDateProvider = FutureProvider.family<List<Workout>, DateTime>((ref, date) async {
  final db = ref.watch(databaseProvider);
  return await db.getWorkoutsByDate(date);
});

final workoutsByExerciseProvider = FutureProvider.family<List<Workout>, int>((ref, exerciseId) async {
  final db = ref.watch(databaseProvider);
  return await db.getWorkoutsByExercise(exerciseId);
}); 