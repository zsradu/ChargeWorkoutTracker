import '../models/exercise.dart';

class PredefinedExercises {
  static final List<Exercise> exercises = [
    // Chest
    Exercise(name: 'Barbell Bench Press', muscleGroup: 'Chest'),
    Exercise(name: 'Dumbbell Bench Press', muscleGroup: 'Chest'),
    Exercise(name: 'Incline Bench Press', muscleGroup: 'Chest'),
    Exercise(name: 'Push-ups', muscleGroup: 'Chest'),
    Exercise(name: 'Dumbbell Flyes', muscleGroup: 'Chest'),

    // Back
    Exercise(name: 'Barbell Deadlift', muscleGroup: 'Back'),
    Exercise(name: 'Pull-ups', muscleGroup: 'Back'),
    Exercise(name: 'Barbell Rows', muscleGroup: 'Back'),
    Exercise(name: 'Lat Pulldowns', muscleGroup: 'Back'),
    Exercise(name: 'Dumbbell Rows', muscleGroup: 'Back'),

    // Legs
    Exercise(name: 'Barbell Squat', muscleGroup: 'Legs'),
    Exercise(name: 'Romanian Deadlift', muscleGroup: 'Legs'),
    Exercise(name: 'Leg Press', muscleGroup: 'Legs'),
    Exercise(name: 'Lunges', muscleGroup: 'Legs'),
    Exercise(name: 'Calf Raises', muscleGroup: 'Legs'),

    // Shoulders
    Exercise(name: 'Military Press', muscleGroup: 'Shoulders'),
    Exercise(name: 'Dumbbell Shoulder Press', muscleGroup: 'Shoulders'),
    Exercise(name: 'Lateral Raises', muscleGroup: 'Shoulders'),
    Exercise(name: 'Front Raises', muscleGroup: 'Shoulders'),
    Exercise(name: 'Face Pulls', muscleGroup: 'Shoulders'),

    // Arms
    Exercise(name: 'Barbell Bicep Curls', muscleGroup: 'Arms'),
    Exercise(name: 'Dumbbell Bicep Curls', muscleGroup: 'Arms'),
    Exercise(name: 'Tricep Pushdowns', muscleGroup: 'Arms'),
    Exercise(name: 'Skull Crushers', muscleGroup: 'Arms'),
    Exercise(name: 'Hammer Curls', muscleGroup: 'Arms'),

    // Core
    Exercise(name: 'Crunches', muscleGroup: 'Core'),
    Exercise(name: 'Planks', muscleGroup: 'Core'),
    Exercise(name: 'Russian Twists', muscleGroup: 'Core'),
    Exercise(name: 'Leg Raises', muscleGroup: 'Core'),
    Exercise(name: 'Wood Choppers', muscleGroup: 'Core'),
  ];

  static final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
  ];
} 