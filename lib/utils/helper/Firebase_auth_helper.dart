
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';


class FireBaseAuthHelper {
  FireBaseAuthHelper._();

  static final FireBaseAuthHelper fireBaseAuthHelper = FireBaseAuthHelper._();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  //
  // Future<User?>signInWithAnonymous()async{
  //   UserCredential userCredential = await firebaseAuth.signInAnonymously();
  //   User? user = userCredential.user;
  //   return user;
  // }

  Future<void> LoginOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<Map<String, dynamic>> signInWithAnonymous() async {
    Map<String, dynamic> data = {};
    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporarily not available..";
          break;
        case "network-request-failed":
          data["msg"] = "Internet connection not available..";
          break;
        default:
          data["msg"] = e.code;
      }
    }
    return data;
  }

  Future<Map<String, dynamic>> signupWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      data['user'] = user;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service temporary down";
        case "weak-password":
          data['msg'] = "Password must be grater than 6 char.";
        case "email-already-in-use":
          data['msg'] = "User with this email id is already exists";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }


  Future<Map<String, dynamic>> signinWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
      data["msg"] =  "This service temporary down";
          break;
        case "wrong-password":
          data["msg"] = "Password is wrong";
          break;
        case "user-not-found":
          data["msg"] = "User does not exists with this email id";
          break;
        case "user-disabled":
          data["msg"] =  "User is disabled ,contact admin";
          break;
        default:
          data["msg"] =  e.code;
          break;
      }
    }
    return data;
  }


  Future<void> linkAccount({required String email,required String  password}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);
      UserCredential authResult = await user.linkWithCredential(credential);
      User? user1 = authResult.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }



  //google log in

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      data['msg'] = "No internet connection";
      return data;
    }
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporarily down";
          break;
        default:
          data['msg'] = e.code;
          break;
      }
    }
    return data;
  }





}
