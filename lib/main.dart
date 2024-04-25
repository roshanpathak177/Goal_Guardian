import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goal_guardian/auth/login_or_register.dart';
import 'package:goal_guardian/components/side_navbar.dart';
import 'package:goal_guardian/pages/create_goal_page.dart';
import 'package:goal_guardian/pages/groups.dart';
import 'package:goal_guardian/pages/intro.dart';
import 'package:goal_guardian/pages/stats.dart';
import 'package:goal_guardian/pages/user_profile.dart';
import 'package:goal_guardian/firebase_options.dart';
import 'package:goal_guardian/theme/theme.dart';
// import 'package:goal_guardian/pages/intro.dart';


// import 'package:goal_guardian/pages/login_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Guardian',
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      darkTheme: darkmode,
      home: LogingOrRegister(),
      routes: {
        '/create_goal': (context) => CreateGoalPage(),
        '/groups': (context) => GroupsPage(),
        '/stats': (context) => StatsPage(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Text("Track your Goals!"),
    GroupsPage(),
    StatsPage(),
    ProfilePage(),
  ]; 

  void _navigateToCreateGoalPage() {
  Navigator.pushNamed(context, '/create_goal');
}

  final List<Habit> _habits = [
    Habit(
      name: 'Daily Exercise',
      progress: 80,
      totalTime: 3600, // in seconds
      avgTime: 300, // in seconds
    ),
    Habit(
      name: 'Reading',
      progress: 65,
      totalTime: 7200, // in seconds
      avgTime: 600, // in seconds
    ),
    Habit(
      name: 'Meditation',
      progress: 90,
      totalTime: 10800, // in seconds
      avgTime: 900, // in seconds
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: SideNavBar(),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [const Text("Track your Goals!"),
        _buildMotivationalSection(),
        const SizedBox(height: 15),
        _buildHabitsSection(),
        const SizedBox(height: 15),
        _buildQuickActionsSection(),
        const SizedBox(height: 15),
        _buildSocialSection(),],
        )
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.grey,
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
            backgroundColor: Colors.grey,
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Stats',
            backgroundColor: Colors.grey,
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.grey,
            ),
        ],
        onTap: (index){
          setState((){
            _currentIndex = index;
            if (index == 1) { // Check if "Groups" tab is tapped
              Navigator.pushNamed(context, '/groups'); // Navigate to the GroupsPage route
            }
            if (index == 2) { // Check if "Stats" tab is tapped
              Navigator.pushNamed(context, '/stats'); // Navigate to the StatsPage route
            }
            if (index == 3) { // Check if "Stats" tab is tapped
              Navigator.pushNamed(context, '/profile'); // Navigate to the StatsPage route
            }
          });
        },
        ),
    );
  }
  Widget _buildMotivationalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Stay Motivated',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '"Believe you can and youre halfway there."',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Theodore Roosevelt',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Habits',
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

  Widget _buildQuickActionsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _navigateToCreateGoalPage, // Call the navigation method
          icon: const Icon(Icons.add),
          label: const Text('Create Goal'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to add new habit page
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Habit'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to schedule page
          },
          icon: const Icon(Icons.calendar_today),
          label: const Text('View Schedule'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to stats page
          },
          icon: const Icon(Icons.bar_chart),
          label: const Text('View Stats'),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect with Others',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to groups page
              },
              icon: const Icon(Icons.group),
              label: const Text('Join Groups'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to leaderboard page
              },
              icon: const Icon(Icons.leaderboard),
              label: const Text('Leaderboard'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to share progress page
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Progress'),
            ),
          ],
        ),
      ],
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
  final int progress;
  final int totalTime;
  final int avgTime;

  Habit({
    required this.name,
    required this.progress,
    required this.totalTime,
    required this.avgTime,
  });
}

