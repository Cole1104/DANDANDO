import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get uid => _auth.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> taskCollection(
    String collectionName,
  ) {
    return _firestore.collection('users').doc(uid).collection(collectionName);
  }

  Future<void> addTask(String collectionName, Task task) async {
    await taskCollection(collectionName).doc(task.id).set(task.toJson());
  }

  Stream<List<Task>> getTasks(String collectionName) {
    return taskCollection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromFirestore(doc.data()))
          .toList();
    });
  }

  Future<void> updateTask(String collectionName, Task task) async {
    await taskCollection(collectionName).doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String collectionName, String taskId) async {
    await taskCollection(collectionName).doc(taskId).delete();
  }
}
