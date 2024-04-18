import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final String photoUrl;
  final String description;
  final List<String> memberIds;
  int get memberCount => memberIds.length;

  Group({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.memberIds,
  });

  factory Group.fromMap(Map<String, dynamic> data, String documentId) {
    return Group(
      id: documentId,
      name: data['name'],
      photoUrl: data['photoUrl'],
      description: data['description'],
      memberIds: List<String>.from(data['memberIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'description': description,
      'memberIds': memberIds,
    };
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGroup(Group group) async {
    await _firestore.collection('groups').add(group.toMap());
  }

  Future<List<Group>> getGroups() async {
    final querySnapshot = await _firestore.collection('groups').get();
    return querySnapshot.docs.map((doc) => Group.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateGroup(Group group) async {
    await _firestore.collection('groups').doc(group.id).update(group.toMap());
  }

  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection('groups').doc(groupId).delete();
  }

  Future<void> joinGroup(Group group, String userId) async {
    await _firestore.collection('groups').doc(group.id).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> leaveGroup(Group group, String userId) async {
    await _firestore.collection('groups').doc(group.id).update({
      'memberIds': FieldValue.arrayRemove([userId]),
    });
  }
}

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<Group> _groups = [];
  final String _searchQuery = '';
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    _groups = await _firestoreService.getGroups();
    setState(() {});
  }

  Future<void> _toggleGroupMembership(Group group) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (group.memberIds.contains(user.uid)) {
        await _firestoreService.leaveGroup(group, user.uid);
      } else {
        await _firestoreService.joinGroup(group, user.uid);
      }
      setState(() {
        group.memberIds.contains(user.uid)
            ? group.memberIds.remove(user.uid)
            : group.memberIds.add(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: GroupsSearchDelegate(_firestoreService),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupPage(firestoreService: _firestoreService)),
              );
            },
          ),],
      ),
      body: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          return GroupTile(
            group: group,
            onJoinLeave: () {
              _toggleGroupMembership(group);
            },
          );
        },
      ),
    );
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
          child: Text(group.memberIds.contains(FirebaseAuth.instance.currentUser?.uid) ? 'Leave' : 'Join'),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class GroupsSearchDelegate extends SearchDelegate<void> {
  final FirestoreService firestoreService; // Use constructor parameter name

  GroupsSearchDelegate(this.firestoreService);

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Group>>(
      stream: firestoreService.getGroupsStream(), // Use stream for real-time updates
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredGroups = snapshot.data!
            .where((group) => group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: filteredGroups.length,
          itemBuilder: (context, index) {
            final group = filteredGroups[index];
            return GroupTile(
              group: group,
              onJoinLeave: () => _toggleGroupMembership(group), // Use arrow function
            );
          },
        );
      },
    );
  }

  @override // Make sure 'showResults' is implemented
  void showResults(BuildContext context) {
    // No need to show results separately if suggestions handle display
  }

  Future<void> _toggleGroupMembership(Group group) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (group.memberIds.contains(user.uid)) {
        await firestoreService.leaveGroup(group, user.uid);
      } else {
        await firestoreService.joinGroup(group, user.uid);
      }
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null); // Close search delegate on clear (null result)
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // Use arrow function and null result
    );
  }
}


class CreateGroupPage extends StatefulWidget {
  final FirestoreService firestoreService;

  const CreateGroupPage({super.key, required this.firestoreService});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = '';
  String _groupDescription = '';
  String _groupPhotoUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _auth.currentUser;
      if (user != null) {
        final newGroup = Group(
          id: UniqueKey().toString(),
          name: _groupName,
          photoUrl: _groupPhotoUrl,
          description: _groupDescription,
          memberIds: [user.uid],
        );
        await widget.firestoreService.createGroup(newGroup);
        Navigator.pop(context);
      }
    }
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
                onPressed: _createGroup,
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}