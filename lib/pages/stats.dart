import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  // Sample data for habits
  final List<Habit> _habits = [
    Habit(
      name: 'Daily Exercise',
      currentStreak: 14,
      longestStreak: 30,
      totalTime: 3600, // in seconds
      avgTime: 300, // in seconds
      
    ),
    Habit(
      name: 'Reading',
      currentStreak: 7,
      longestStreak: 21,
      totalTime: 7200, // in seconds
      avgTime: 600, // in seconds
      
    ),
    Habit(
      name: 'Meditation',
      currentStreak: 21,
      longestStreak: 45,
      totalTime: 10800, // in seconds
      avgTime: 900, // in seconds
    ),
  ];

  // Selected time period for filtering
  String _selectedTimePeriod = 'Last 30 days';
  final List<String> _timePeriodOptions = ['Last 30 days', 'Last 3 months', 'Last 6 months', 'All time'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall progress section
              _buildOverallProgressSection(),
              const SizedBox(height: 24),

              // Habits section
              _buildHabitsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgressSection() {
    final totalHabits = _habits.length;
    final completedHabits = _habits.where((habit) => habit.currentStreak > 0).length;
    final points = 100; // Sample points calculation

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overall Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Habits: $totalHabits'),
                const SizedBox(height: 4),
                Text('Completed Habits: $completedHabits'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Points: $points'),
                const SizedBox(height: 4),
                Text('Level: 2'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedTimePeriod,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTimePeriod = newValue;
              });
            }
          },
          items: _timePeriodOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ...List.generate(_habits.length, (index) {
          final habit = _habits[index];
          return _buildHabitCard(habit);
        }),
      ],
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final streakData = [
      charts.Series<int, String>(
        id: 'Streak',
        domainFn: (int streak, _) => '$streak',
        measureFn: (int streak, _) => streak,
        data: [habit.currentStreak, habit.longestStreak],
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Streak: ${habit.currentStreak}'),
                    const SizedBox(height: 4),
                    Text('Longest Streak: ${habit.longestStreak}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Time: ${_formatTime(habit.totalTime)}'),
                    const SizedBox(height: 4),
                    Text('Avg Time: ${_formatTime(habit.avgTime)}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: charts.BarChart(
                streakData,
                animate: true,
                behaviors: [
                  charts.SeriesLegend(),
                  charts.ChartTitle('Streak'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$remainingSeconds';
  }
}

class Habit {
  final String name;
  final int currentStreak;
  final int longestStreak;
  final int totalTime;
  final int avgTime;

  Habit({
    required this.name,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalTime,
    required this.avgTime,
  });
}
// Stats Page:
// The stats page should provide a comprehensive overview of the user's progress and performance across their various habits or challenges.
// It can have a dashboard-style layout, with different sections or widgets displaying various statistics and visualizations.
// One section can show the user's overall progress, such as the total number of habits or challenges they have signed up for, the number of completed or ongoing ones, and their overall points or level.
// Another section can display detailed statistics for each habit or challenge, such as:
// Streak information (e.g., longest streak, current streak)
// Time-based metrics (e.g., total time spent, average time per session)
// Comparison of progress between different habits or challenges
// Users should be able to filter or sort the data based on different criteria, such as time period or habit type.
// The page can include visual elements, such as graphs, charts, or progress bars, to help users better understand their performance and progress.