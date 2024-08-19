// import 'dart:js_interop';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late AuthService _authService;

  CollectionReference? _userCollection;
  CollectionReference? _chatsCollection;

  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              // type safety built in it;
              fromFirestore: (snapshot, _) => UserProfile.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );
    _chatsCollection =
        _firebaseFirestore.collection('chats').withConverter<Chat>(
              fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.uid).set(
          userProfile,
        ); // if left empty automatically filled; instance of userProfile;
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    // i don't understand this part
    return _userCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);

    final result = await _chatsCollection?.doc(chatID).get();

    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);

    final docRef = _chatsCollection!.doc(chatID); // ?

    final chat = Chat(
      id: chatID,
      participants: [uid1, uid2],
      messages: [],
    );

    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID); // ?
    await docRef.update(
      {
        "message": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) { // update document to firestore and stream to show us the data from firestore
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
