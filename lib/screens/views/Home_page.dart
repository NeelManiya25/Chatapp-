import 'package:chat_app/screens/views/profile_screen.dart';
import 'package:chat_app/utils/helper/Firebase_auth_helper.dart';
import 'package:chat_app/utils/helper/firestore_core_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../modal/chat_user_model.dart';
import '../../widget/chat_user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireStoreHelper.fireStoreHelper.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      print("Message :${message}");
      if(message.toString().contains('resume')) FireStoreHelper.updateActiveStatus(true);
      if(message.toString().contains('pause')) FireStoreHelper.updateActiveStatus(false);
      return Future.value(message);
    });


  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];

  bool _isSearching = false;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching = false;
            });
          return Future.value(false);
          }else{
            return Future.value(true);          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name , Email...",
                    ),
                    onChanged: (value) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                            i.email.toLowerCase().contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text("Chat App", style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(CupertinoIcons.power),
              ),
              IconButton(
                onPressed: () {
                  Get.to(profile_Screen(user: FireStoreHelper.me));
                },
                icon: const Icon(CupertinoIcons.table_badge_more),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: FireStoreHelper.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                // TODO: Handle this case.
                case ConnectionState.waiting:
                  // TODO: Handle this case.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                // TODO: Handle this case.
                case ConnectionState.done:
                  // TODO: Handle this case.

                  final data = snapshot.data?.docs;
                  list = data!.map((e) => ChatUser.fromJson(e.data())).toList();

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _isSearching ? _searchList.length : list.length,
                      padding: EdgeInsets.only(
                        top: Get.height * 0.01,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return chatUser_Card(
                          user: _isSearching ? _searchList[index] : list[index],
                        );
                        // return Text("Name : ${list[index]}");
                      },
                    );
                  } else {
                    return Center(child: Text("No Connection Found"));
                  }
              }
            },
          ),
          // body: SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Form(
          //       key: _formKey,
          //       child: Column(
          //         children: [
          //           TextFormField(
          //             controller: _emailController,
          //             decoration: const InputDecoration(labelText: 'Email'),
          //             validator: (value) =>
          //                 (value!.isEmpty) ? "Enter a Email" : null,
          //             onSaved: (value) {
          //               email = value;
          //             },
          //           ),
          //           TextFormField(
          //             controller: _passwordController,
          //             obscureText: true,
          //             decoration: const InputDecoration(labelText: 'Password'),
          //             validator: (value) =>
          //                 (value!.isEmpty) ? "Enter a Password" : null,
          //             onSaved: (value) {
          //               password = value;
          //             },
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               linkAccount();
          //             },
          //             child: const Text('Link Account'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FireBaseAuthHelper.fireBaseAuthHelper.LoginOut();
    Get.offAllNamed("/");
    Get.snackbar(
      "Signed Out",
      "You have been successfully signed out",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> linkAccount() async {
    if (_formKey.currentState!.validate()) {
      (_formKey.currentState!.save());

      await FireBaseAuthHelper.fireBaseAuthHelper
          .linkAccount(email: email!, password: password!);
      Get.snackbar(
        'Successfully',
        "Linked Successfully",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
