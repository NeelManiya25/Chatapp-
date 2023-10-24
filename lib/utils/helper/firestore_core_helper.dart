import 'dart:io';

import 'package:chat_app/modal/chat_user_model.dart';
import 'package:chat_app/modal/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static get user => firebaseAuth.currentUser!;

  //checking user exit or not
  Future<bool> userExit() async {
    return (await db.collection('users').doc(user.uid).get()).exists;
  }

  Future<void> getSelfInfo() async {
    await db.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
       await getFirebaseMessagingToken();
        print(" my data :${user.data()!}");
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //create a new user

  Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      image: user.photoURL.toString(),
      about: "Hey , I am Using chat app",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      email: user.email.toString(),
      pushToken: '',
    );
    return await db.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  //for getting all user from firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return db
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  Future<void> updateUserinfo() async {
    await db.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    print(ext);
    final ref = storage.ref().child("Profile picture/${user.uid}.$ext");
    ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      print("Data transfer :${p0.bytesTransferred / 1000} kb");
    });

    me.image = await ref.getDownloadURL();
    await db.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return db
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref =
        db.collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    db
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return db
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return db
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    db.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  //firebase messaging
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        print("Push Token :$token");
      }
    });
  }
}

//
// class YourAuthClass {
//   static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   static User get user => _firebaseAuth.currentUser!;
//
// }
//
// User currentUser = YourAuthClass.user;
