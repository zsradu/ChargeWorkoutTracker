import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import 'database_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final workoutsByDateProvider = FutureProvider.family<List<Workout>, DateTime>((ref, date) async {
  final normalizedDate = DateTime.utc(date.year, date.month, date.day);
  final db = ref.watch(databaseProvider);
  final workouts = await db.getWorkoutsByDate(normalizedDate);
  print('Fetching workouts for $normalizedDate: $workouts');
  return workouts;
  // return await db.getWorkoutsByDate(date);
});

final workoutsByExerciseProvider = FutureProvider.family<List<Workout>, int>((ref, exerciseId) async {
  final db = ref.watch(databaseProvider);
  return await db.getWorkoutsByExercise(exerciseId);
}); 