import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_list.dart';
import '../widgets/date_selector.dart';
import 'select_exercise_screen.dart';
import 'calendar_screen.dart';

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(workoutsByDateProvider(ref.read(selectedDateProvider)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await Navigator.push<DateTime>(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).state = picked;
                // Refresh data when date changes
                ref.invalidate(workoutsByDateProvider(picked));
              }
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          DateSelector(),
          Expanded(
            child: WorkoutList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectExerciseScreen(),
            ),
          );
          // Refresh data when returning from adding a workout
          ref.invalidate(workoutsByDateProvider(selectedDate));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 