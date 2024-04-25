
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goal_guardian/components/goal.dart';
import 'package:goal_guardian/firebase_options.dart';
import 'package:goal_guardian/components/partner_or_group_selector.dart';

class CreateGoalPage extends StatefulWidget {
  @override
  _CreateGoalPageState createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final _formKey = GlobalKey<FormState>();
  String _goalTitle = '';
  String _goalDescription = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String _goalType = 'daily';
  String _accountabilityType = 'partner';
  String? _partnerId;
  String? _groupId;

  // Add necessary input fields and validation logic

  Future<void> _createGoal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final goal = Goal(
        id: UniqueKey().toString(),
        title: _goalTitle,
        description: _goalDescription,
        startDate: _startDate,
        endDate: _endDate,
        type: _goalType,
        accountabilityType: _accountabilityType,
        partnerId: _partnerId,
        groupId: _groupId,
        dailyInputs: <DailyInput>[], // Initialize with an empty list
      );

      // Save the goal to Firestore
      await FirebaseFirestore.instance.collection('goals').add(goal.toMap());

      // Navigate back or show a success message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add form fields for goal title, description, dates, type, and accountability type
              DropdownButtonFormField<String>(
                value: _accountabilityType,
                onChanged: (value) {
                  setState(() {
                    _accountabilityType = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'partner',
                    child: Text('Accountability Partner'),
                  ),
                  DropdownMenuItem(
                    value: 'group',
                    child: Text('Accountability Group'),
                  ),
                ],
              ),
              if (_accountabilityType == 'partner')
                // Add a field to select an accountability partner
                ...[
                  PartnerOrGroupSelector(
                  accountabilityType: 'partner',
                  onSelected: (value) {
                    setState(() {
                      _partnerId = value;
                    });
                  },
                )
              ]
              else
                // Add a field to select an accountability group
                ...[
                  PartnerOrGroupSelector(
                  accountabilityType: 'group',
                  onSelected: (value) {
                    setState(() {
                      _groupId = value;
                    });
                  },
                )
              ],
              ElevatedButton(
                onPressed: _createGoal,
                child: const Text('Create Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}