import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _profilePicUrl = 'https://via.placeholder.com/150';
  int _points = 500;
  int _level = 3;

  // Sample user habits
  final List<Habit> _habits = [
    Habit(
      name: 'Daily Exercise',
      description: 'Complete a 30-minute workout every day',
      progress: 80,
      totalTime: 3600, // in seconds
      avgTime: 300, // in seconds
    ),
    Habit(
      name: 'Reading',
      description: 'Read for at least 30 minutes per day',
      progress: 65,
      totalTime: 7200, // in seconds
      avgTime: 600, // in seconds
    ),
    Habit(
      name: 'Meditation',
      description: 'Meditate for 20 minutes every day',
      progress: 90,
      totalTime: 10800, // in seconds
      avgTime: 900, // in seconds
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfoSection(),
              const SizedBox(height: 24),
              _buildPointsAndLevelSection(),
              const SizedBox(height: 24),
              _buildHabitsSection(),
              const SizedBox(height: 24),
              _buildAchievementsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(_profilePicUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(_email),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _editProfile,
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPointsAndLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Points and Level',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Points: $_points'),
            Text('Level: $_level'),
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
        ...List.generate(_habits.length, (index) {
          final habit = _habits[index];
          return _buildHabitCard(habit);
        }),
      ],
    );
  }

  Widget _buildHabitCard(Habit habit) {
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
            Text(habit.description),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: habit.progress / 100,
              color: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Time: ${_formatTime(habit.totalTime)}'),
                Text('Avg Time: ${_formatTime(habit.avgTime)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Add achievement cards or widgets here
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Consistent Learner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Completed 30 days of reading'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _editProfile() {
    // Navigate to edit profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
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
  final String description;
  final int progress;
  final int totalTime;
  final int avgTime;

  Habit({
    required this.name,
    required this.description,
    required this.progress,
    required this.totalTime,
    required this.avgTime,
  });
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _password = 'password123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the updated profile information
      // ...
      Navigator.pop(context);
    }
  }
}// User Profile Page:
// The user profile page should display the user's basic information, such as their name, email, and profile picture.
// It should show the user's current points or level, which can be based on their progress in the habits or challenges they have signed up for.
// A section can display the user's current habits or challenges, with the ability to view details of each one, such as the habit's name, description, progress, and any associated statistics.
// Users should be able to edit their profile information, including changing their password or email.
// There can be a section for the user to view their past achievements or milestones reached.
