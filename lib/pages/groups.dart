import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // List of groups the user has joined
  final List<Group> _groups = [
    Group(
      name: 'Fitness Enthusiasts',
      photoUrl: 'assets/images/fitness_group.jpeg',
      description: 'A group for people passionate about fitness and healthy living.',
      memberCount: 234,
    ),
    Group(
      name: 'Book Club',
      photoUrl: 'assets/images/book_club.jpeg',
      description: 'A group for book lovers to discuss and share their favorite reads.',
      memberCount: 112,
    ),
    Group(
      name: 'Productivity Hackers',
      photoUrl: 'assets/images/productivity_group.jpeg',
      description: 'A group dedicated to sharing tips and tricks for increasing productivity.',
      memberCount: 78,
    ),
  ];

  // Search query
  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search bar
              showSearch(
                context: context,
                delegate: GroupsSearchDelegate(_groups),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create new group page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupPage(groups: [],)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredGroups().length,
        itemBuilder: (context, index) {
          final group = _filteredGroups()[index];
          return GroupTile(
            group: group,
            onJoinLeave: () {
              // Join or leave the group
              _toggleGroupMembership(group);
            },
          );
        },
      ),
    );
  }

  List<Group> _filteredGroups() {
    if (_searchQuery.isEmpty) {
      return _groups;
    } else {
      return _groups.where((group) =>
          group.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  void _toggleGroupMembership(Group group) {
    // Logic to join or leave the group
    setState(() {
      // Update the group's member count
      group.memberCount += group.isMember ? -1 : 1;
      group.isMember = !group.isMember;
    });
  }
}

class GroupTile extends StatelessWidget {
  final Group group;
  final VoidCallback onJoinLeave;

  const GroupTile({
    Key? key,
    required this.group,
    required this.onJoinLeave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(group.photoUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(group.name),
        subtitle: Text(group.description),
        trailing: TextButton(
          onPressed: onJoinLeave,
          child: Text(group.isMember ? 'Leave' : 'Join'),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class GroupsSearchDelegate extends SearchDelegate<String> {
  final List<Group> _groups;
  

  GroupsSearchDelegate(this._groups);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredGroups = _groups.where((group) =>
        group.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: filteredGroups.length,
      itemBuilder: (context, index) {
        final group = filteredGroups[index];
        return GroupTile(
          group: group,
          onJoinLeave: () {
            // Join or leave the group
            // _toggleGroupMembership(group);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredGroups = _groups.where((group) =>
        group.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: filteredGroups.length,
      itemBuilder: (context, index) {
        final group = filteredGroups[index];
        return GroupTile(
          group: group,
          onJoinLeave: () {
            // Join or leave the group
            // _toggleGroupMembership(group);
          },
        );
      },
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  final List<Group> groups;
  const CreateGroupPage({super.key, required this.groups});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = '';
  String _groupDescription = '';
  String _groupPhotoUrl = '';

  late List<Group> _groups;

  @override
  void initState() {
    super.initState();
    _groups = widget.groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupName = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Group Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupDescription = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Group Photo URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group photo URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupPhotoUrl = value!;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create the new group
                    final newGroup = Group(
                      name: _groupName,
                      photoUrl: _groupPhotoUrl,
                      description: _groupDescription,
                      memberCount: 1, // The creator is the first member
                      isMember: true,
                    );
                    // Add the new group to the list and update the UI
                    setState(() {
                      _groups.add(newGroup);
                    });
                    // Navigate back to the Groups page
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Group {
  final String name;
  final String photoUrl;
  final String description;
  int memberCount;
  bool isMember;

  Group({
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.memberCount,
    this.isMember = false,
  });
}