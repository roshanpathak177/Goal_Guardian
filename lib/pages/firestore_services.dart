import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goal_guardian/components/group.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGroup(Group group) async {
    await _firestore.collection('groups').add(group.toMap());
  }

  Future<List<Group>> getGroups() async {
    final querySnapshot = await _firestore.collection('groups').get();
    return querySnapshot.docs.map((doc) => Group.fromMap(doc.data(), doc.id)).toList();
  }

  Stream<List<Group>> getGroupsStream() {
    return _firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Group.fromMap(doc.data(), doc.id)).toList();
    });
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