import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/exercises.dart';
import '../providers/database_provider.dart';

class InitializationService {
  static Future<void> initializeDatabase(Ref ref) async {
    final db = ref.read(databaseProvider);
    final exercises = await db.getExercises();

    if (exercises.isEmpty) {
      for (final exercise in PredefinedExercises.exercises) {
        await db.insertExercise(exercise);
      }
    }
  }
} 