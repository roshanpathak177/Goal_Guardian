import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerOrGroupSelector extends StatefulWidget {
  final String accountabilityType;
  final Function(String?) onSelected;

  const PartnerOrGroupSelector({
    Key? key,
    required this.accountabilityType,
    required this.onSelected,
  }) : super(key: key);

  @override
  _PartnerOrGroupSelectorState createState() => _PartnerOrGroupSelectorState();
}

class _PartnerOrGroupSelectorState extends State<PartnerOrGroupSelector> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.accountabilityType == 'partner' ? 'users' : 'groups')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final items = snapshot.data!.docs.map((doc) {
          final id = doc.id;
          final data = doc.data() as Map<String, dynamic>;
          final name = data.containsKey('name') ? data['name'] : '';
          return DropdownMenuItem<String>(
            value: id,
            child: Text(name),
          );
        }).toList();

        return DropdownButtonFormField<String>(
          value: _selectedId,
          onChanged: (value) {
            setState(() {
              _selectedId = value;
            });
            widget.onSelected(value);
          },
          items: items,
          decoration: InputDecoration(
            labelText: widget.accountabilityType == 'partner'
                ? 'Select Accountability Partner'
                : 'Select Accountability Group',
          ),
        );
      },
    );
  }
}