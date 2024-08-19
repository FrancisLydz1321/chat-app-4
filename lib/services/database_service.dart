import 'package:chat_app/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _userCOllection;

  DatabaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCOllection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              // type safety built in it;
              fromFirestore: (snapshot, _) => UserProfile.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCOllection?.doc(userProfile.uid).set(
        userProfile); // if left empty automatically filled; instance of userProfile;
  }
}
