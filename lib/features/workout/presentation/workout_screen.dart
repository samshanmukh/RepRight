import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add workout screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTodayWorkoutCard(context),
          const SizedBox(height: 24),
          _buildSectionHeader('This Week'),
          const SizedBox(height: 12),
          _buildWorkoutCard(
            context,
            'Monday - Push Day',
            'Chest, Shoulders, Triceps',
            '60 min',
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          _buildWorkoutCard(
            context,
            'Tuesday - Pull Day',
            'Back, Biceps',
            '55 min',
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          _buildWorkoutCard(
            context,
            'Wednesday - Leg Day',
            'Quads, Hamstrings, Calves',
            '70 min',
            isCompleted: false,
          ),
          const SizedBox(height: 12),
          _buildWorkoutCard(
            context,
            'Thursday - Upper Body',
            'Chest, Back, Arms',
            '65 min',
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWorkoutCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Workout',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Leg Day',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quads, Hamstrings, Calves',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  '70 min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Start workout - navigate to camera screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text('Start Workout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWorkoutCard(
    BuildContext context,
    String title,
    String muscles,
    String duration, {
    required bool isCompleted,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.1)
                : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.fitness_center,
            color: isCompleted ? Colors.green : theme.colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(muscles),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text(duration),
              ],
            ),
          ],
        ),
        trailing: isCompleted
            ? null
            : const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to workout detail
        },
      ),
    );
  }
}
