import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../constants/theme.dart';
import 'exercise_logging_screen.dart';

class SelectExerciseScreen extends ConsumerWidget {
  const SelectExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muscleGroups = ref.watch(muscleGroupsProvider);

    return DefaultTabController(
      length: muscleGroups.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Exercise'),
          bottom: TabBar(
            isScrollable: true,
            tabs: muscleGroups
                .map((group) => Tab(text: group))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: muscleGroups.map((group) {
            return ExerciseList(muscleGroup: group);
          }).toList(),
        ),
      ),
    );
  }
}

class ExerciseList extends ConsumerWidget {
  final String muscleGroup;

  const ExerciseList({
    super.key,
    required this.muscleGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesByMuscleGroupProvider(muscleGroup));

    return exercisesAsync.when(
      data: (exercises) {
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Card(
              child: ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.muscleGroup),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseLoggingScreen(
                        exercise: exercise,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading exercises')),
    );
  }
} 