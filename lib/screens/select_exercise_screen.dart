import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../constants/theme.dart';
import '../models/exercise.dart';
import 'exercise_logging_screen.dart';
import '../providers/database_provider.dart';

class SelectExerciseScreen extends ConsumerWidget {
  final bool isProgressScreen;

  const SelectExerciseScreen({
    super.key,
    this.isProgressScreen = false,
  });

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
            return ExerciseList(
              muscleGroup: group,
              isProgressScreen: isProgressScreen,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddExerciseDialog(context, ref);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final muscleGroupController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: muscleGroupController,
              decoration: const InputDecoration(
                labelText: 'Muscle Group',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && muscleGroupController.text.isNotEmpty) {
                final exercise = Exercise(
                  name: nameController.text,
                  muscleGroup: muscleGroupController.text,
                  isCustom: true,
                );
                await ref.read(databaseProvider).insertExercise(exercise);
                ref.invalidate(exercisesProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class ExerciseList extends ConsumerWidget {
  final String muscleGroup;
  final bool isProgressScreen;

  const ExerciseList({
    super.key,
    required this.muscleGroup,
    required this.isProgressScreen,
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
                  if (isProgressScreen) {
                    Navigator.pop(context, exercise);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseLoggingScreen(
                          exercise: exercise,
                        ),
                      ),
                    );
                  }
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