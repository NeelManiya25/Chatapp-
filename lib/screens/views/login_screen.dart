import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import '../../utils/helper/Firebase_auth_helper.dart';
import '../../utils/attributes/constant.dart';
import '../../utils/attributes/dialog.dart';
import '../../utils/helper/firestore_core_helper.dart';

class login_Screen extends StatefulWidget {
  const login_Screen({Key? key}) : super(key: key);

  @override
  State<login_Screen> createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  final GlobalKey<FormState> signinKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupKey = GlobalKey<FormState>();

  final TextEditingController SignInEmailController = TextEditingController();
  final TextEditingController SignInPasswordController =
      TextEditingController();

  final TextEditingController SignUpEmailController = TextEditingController();
  final TextEditingController SignUpPasswordController =
      TextEditingController();
  final TextEditingController SignUpNameController = TextEditingController();
  final TextEditingController SignUpConfirmPasswordController =
      TextEditingController();

  String? Email;
  String? Password;

  String? SignUpName;
  String? SignUpConfirmPassword;

  int intialIndex = 0;

  late bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  // _handleGoogleBtnClick() {
  //   //for showing progress bar
  //   Dialogs.showProgressBar(context);
  //
  //   _signInWithGoogle().then((user) async {
  //     //for hiding progress bar
  //     Navigator.pop(context);
  //
  //     if (user != null) {
  //       log('\nUser: ${user.user}');
  //       log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
  //
  //       if ((await APIs.userExists())) {
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  //       } else {
  //         await APIs.createUser().then((value) {
  //           Navigator.pushReplacement(
  //               context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: intialIndex,
          children: [
            Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_top.png",
                      height: Get.width * 0.5,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.15,
                        ),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              "Welcome To Chat App",
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.width * 0.05,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        SvgPicture.asset(
                          "assets/icons/chat.svg",
                          height: Get.height * 0.4,
                        ),
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        SizedBox(
                          height: Get.height * 0.062,
                          width: Get.width * 0.85,
                          child: OutlinedButtonTheme(
                            data: OutlinedButtonThemeData(
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.deepPurple,
                                ),
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  intialIndex = 1;
                                });
                              },
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        SizedBox(
                          height: Get.height * 0.062,
                          width: Get.width * 0.85,
                          child: OutlinedButtonTheme(
                            data: OutlinedButtonThemeData(
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  intialIndex = 2;
                                });
                              },
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        const Text(
                          'Made with ♥ by Vivek Baraiya',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: Get.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_top.png",
                      width: Get.width * 0.5,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/images/login_bottom.png",
                      width: Get.height * 0.25,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: signinKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.1,
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                "Login",
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.width * 0.05,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.03),
                          SvgPicture.asset(
                            "assets/icons/login.svg",
                            height: Get.height * 0.3,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                Email = newValue;
                              },
                              validator: (value) =>
                                  (value!.isEmpty) ? "Enter a Email" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.person, color: myCustomColor),
                                hintText: "Email",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                              ),
                              controller: SignInEmailController,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                Password = newValue;
                              },
                              validator: (value) =>
                                  (value!.isEmpty) ? "Enter a Password" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.lock, color: myCustomColor),
                                hintText: "Password",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _passwordVisible
                                        ? myCustomColor
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              controller: SignInPasswordController,
                              obscureText: !_passwordVisible,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: OutlinedButtonTheme(
                              data: OutlinedButtonThemeData(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.deepPurple,
                                  ),
                                ),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  signInWithEmailPassword();
                                },
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const Text(
                          //       "Don’t have an Account ? ",
                          //       style: TextStyle(),
                          //     ),
                          //     GestureDetector(
                          //       child: const Text(
                          //         "Sign Up",
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       onTap: () {},
                          //     )
                          //   ],
                          // ),
                          Text.rich(
                            TextSpan(
                              text: "Don’t have an Account ? ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        intialIndex = 2;
                                      });
                                    },
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Get.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/register_top.png",
                      width: Get.width * 0.35,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_bottom.png",
                      width: Get.height * 0.08,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: signupKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                "SIGNUP",
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.width * 0.05,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.03),
                          SvgPicture.asset(
                            "assets/icons/signup.svg",
                            height: Get.height * 0.24,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                Email = newValue;
                              },
                              validator: (value) =>
                                  (value!.isEmpty) ? "Enter a Email" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.person, color: myCustomColor),
                                hintText: "Email",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                              ),
                              controller: SignUpEmailController,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                SignUpName = newValue;
                              },
                              validator: (value) =>
                                  (value!.isEmpty) ? "Enter a Name" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.person, color: myCustomColor),
                                hintText: "Name",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                              ),
                              controller: SignUpNameController,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                Password = newValue;
                              },
                              validator: (value) =>
                                  (value!.isEmpty) ? "Enter a Password" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.lock, color: myCustomColor),
                                hintText: "Password",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _passwordVisible
                                        ? myCustomColor
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              controller: SignUpPasswordController,
                              obscureText: !_passwordVisible,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: TextFormField(
                              onSaved: (newValue) {
                                SignUpConfirmPassword = newValue;
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? "Enter a Confirm Password"
                                  : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.lock, color: myCustomColor),
                                hintText: "Confirm Password",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _passwordVisible
                                        ? myCustomColor
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              controller: SignUpConfirmPasswordController,
                              obscureText: !_passwordVisible,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          SizedBox(
                            height: Get.height * 0.062,
                            width: Get.width * 0.85,
                            child: OutlinedButtonTheme(
                              data: OutlinedButtonThemeData(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.deepPurple,
                                  ),
                                ),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  signupWithEmailPassword();
                                  // signupWithEmailPassword();
                                },
                                child: const Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "Already have an Account ? ",
                          //       style: TextStyle(),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //       },
                          //       child: Text(
                          //         "Sign In",
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          Text.rich(
                            TextSpan(
                              text: "Don’t have an Account ? ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        intialIndex = 1;
                                      });
                                    },
                                  text: "Sign in",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          const Text("OR"),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap :(){
                                  signInWithFacebook();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/facebook.svg",
                                  height: Get.height * 0.03,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icons/twitter.svg",
                                height: Get.height * 0.03,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  dialogsBox.showProgressBar();
                                  Map<String,dynamic> data =
                                  await FireBaseAuthHelper
                                      .fireBaseAuthHelper.signInWithGoogle();
                                  Get.back();
                                  if (data['user'] != null) {
                                    print('\nUser: ${data['user']}');
                                    if (await FireStoreHelper.fireStoreHelper.userExit()) {
                                      Get.offAllNamed("/HomePage",arguments: data['user']);
                                    } else {
                                      await FireStoreHelper.fireStoreHelper.createUser().then((value) {
                                        Get.offAllNamed("/HomePage",arguments: data['user']);
                                      });
                                    }
                                    Get.snackbar(
                                      'Successfully',
                                      "Login Successfully",
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Failed',
                                      data['msg'],
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                  print("${data['user']}");
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/google-plus.svg",
                                  height: Get.height * 0.03,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  // User? data = await FireBaseAuthHelper
                                  //     .fireBaseAuthHelper
                                  //     .signInWithAnonymous();
                                  // if (data != null) {
                                  //   Get.snackbar(
                                  //     "Successfully",
                                  //     "Successfully Login With Anonymously",
                                  //     backgroundColor: Colors.green,
                                  //     snackPosition: SnackPosition.BOTTOM,
                                  //   );
                                  //   Get.toNamed("/HomePage");
                                  // } else {
                                  //   Get.snackbar(
                                  //     "Failed",
                                  //     "Failed Login With Anonymously ",
                                  //     backgroundColor: Colors.green,
                                  //     snackPosition: SnackPosition.BOTTOM,
                                  //   );
                                  // }
                                  Map<String,dynamic> data = await FireBaseAuthHelper
                                      .fireBaseAuthHelper
                                      .signInWithAnonymous();

                                  if (data['user'] != null) {

                                    Get.snackbar(
                                      "Successfully",
                                      "Successfully Login With Anonymously",
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    Get.toNamed("/HomePage");
                                  }else{
                                    Get.snackbar(
                                      "Failed",
                                      "${data['msg']}",
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.person,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> signupWithEmailPassword() async {
  if (signupKey.currentState != null && signupKey.currentState!.validate()) {
    signupKey.currentState!.save();

    Map<String, dynamic> data = await FireBaseAuthHelper.fireBaseAuthHelper
        .signupWithEmailPassword(email: Email!, password: Password!);

    if (data['user'] != null) {
      Get.snackbar(
        'Successfully',
        "Successfully Login",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      setState(() {
        intialIndex = 1;
      });
      // Get.toNamed("/signup_Verification");
    } else {
      Get.snackbar(
        'Failed',
        data["msg"] ?? 'Unknown error occurred',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}


Future<void> signInWithEmailPassword() async {
  if (signupKey.currentState != null && signupKey.currentState!.validate()) {
    signupKey.currentState!.save();

    Map<String, dynamic> data = await FireBaseAuthHelper.fireBaseAuthHelper
        .signinWithEmailPassword(email: Email!, password: Password!);

    if (data['user'] != null) {
      Get.snackbar(
        'Successfully',
        "Successfully Login",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      Get.toNamed("/HomePage");
    } else {
      Get.snackbar(
        'Failed',
        data["msg"] ?? 'Unknown error occurred',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
