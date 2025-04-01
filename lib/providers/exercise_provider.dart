import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../constants/exercises.dart';
import 'database_provider.dart';

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getExercises();
});

final exercisesByMuscleGroupProvider = FutureProvider.family<List<Exercise>, String>((ref, muscleGroup) async {
  final db = ref.watch(databaseProvider);
  return await db.getExercisesByMuscleGroup(muscleGroup);
});

final muscleGroupsProvider = Provider<List<String>>((ref) {
  return PredefinedExercises.muscleGroups;
}); 