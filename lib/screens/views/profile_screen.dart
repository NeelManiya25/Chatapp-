import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/modal/chat_user_model.dart';
import 'package:chat_app/utils/helper/firestore_core_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/helper/Firebase_auth_helper.dart';

class profile_Screen extends StatefulWidget {
  final ChatUser user;

  const profile_Screen({Key? key, required this.user}) : super(key: key);

  @override
  State<profile_Screen> createState() => _profile_ScreenState();
}

class _profile_ScreenState extends State<profile_Screen> {
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Form(
          key: profileFormKey,
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.03,
                width: Get.width,
              ),
              Stack(
                children: [
                  _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(Get.width * .35),
                          child: Image.file(
                          File(_image!),
                            height: Get.height * 0.2,
                            width: Get.width * 0.43,
                            fit: BoxFit.fill,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(Get.width * .35),
                          child: CachedNetworkImage(
                            imageUrl: widget.user.image,
                            height: Get.height * 0.2,
                            width: Get.width * 0.43,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      color: Colors.white,
                      shape: CircleBorder(),
                      onPressed: () {
                        _showBottomSheet();
                      },
                      child: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: Get.height * 0.03,
                width: Get.width,
              ),
              Text(widget.user.email),
              SizedBox(
                height: Get.height * 0.03,
                width: Get.width,
              ),
              Padding(
                padding: EdgeInsets.all(14),
                child: TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (newValue) =>
                      FireStoreHelper.me.name = newValue ?? "",
                  validator: (value) => (Value != null && value!.isNotEmpty)
                      ? null
                      : "Requrired Field",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    label: Text("Name"),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
                width: Get.width,
              ),
              Padding(
                padding: EdgeInsets.all(14),
                child: TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (newValue) =>
                      FireStoreHelper.me.about = newValue ?? "",
                  validator: (value) => (Value != null && value!.isNotEmpty)
                      ? null
                      : "Requrired Field",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    label: Text("About"),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.1,
                width: Get.width,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (profileFormKey.currentState!.validate()) {
                    profileFormKey.currentState!.save();

                    FireStoreHelper.fireStoreHelper.updateUserinfo().then(
                          (value) => Get.snackbar(
                            "Update",
                            "Update Successfully",
                          ),
                        );
                  }
                },
                icon: Icon(Icons.edit),
                label: Text("UPDATE"),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              signOut();
            },
            label: Text("Log Out"),
            icon: Icon(Icons.logout_outlined),
          ),
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

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Get.height * .03, bottom: Get.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: Get.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(Get.width * .3, Get.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          FireStoreHelper.fireStoreHelper.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(Get.width * .3, Get.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });

                        FireStoreHelper.fireStoreHelper.updateProfilePicture(File(_image!));

                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('assets/images/camera.png'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
