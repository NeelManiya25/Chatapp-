import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/modal/chat_user_model.dart';
import 'package:chat_app/utils/helper/date_utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../modal/message_model.dart';
import '../../utils/helper/firestore_core_helper.dart';
import '../../widget/message_card.dart';

class chat_Screen extends StatefulWidget {
  final ChatUser user;

  const chat_Screen({Key? key, required this.user}) : super(key: key);

  @override
  State<chat_Screen> createState() => _chat_ScreenState();
}

class _chat_ScreenState extends State<chat_Screen> {
  List<Message> _list = [];

  TextEditingController textEditingController = TextEditingController();
  bool showEmoji = false;
  bool _isUploading = false;




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() {
              showEmoji = !showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            title: StreamBuilder(
              stream: FireStoreHelper.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Get.width * .06),
                      child: CachedNetworkImage(
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        height: Get.width * 0.09,
                        width: Get.width * 0.09,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list.isNotEmpty ? list[0].name : widget.user.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Get.width * 0.01,
                        ),
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? "Online"
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
            toolbarHeight: 70,
            actions: [
              IconButton(onPressed: () {

              }, icon: Icon(Icons.video_call_outlined,size: 35,),),
              IconButton(onPressed: () {

              }, icon: Icon(Icons.call,),),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FireStoreHelper.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              // reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: Get.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return message_Card(message: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),
              _chatUser(),
              if (showEmoji)
                SizedBox(
                  height: Get.height * 0.35,
                  child: EmojiPicker(
                    textEditingController: textEditingController,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (Platform.isIOS == TargetPlatform.iOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatUser() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Get.height * .01, horizontal: Get.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => showEmoji = !showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (showEmoji) setState(() => showEmoji = !showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        for (var i in images) {
                          print('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await FireStoreHelper.sendChatImage(
                              widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          setState(() => _isUploading = true);

                          await FireStoreHelper.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  SizedBox(width: Get.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                FireStoreHelper.sendMessage(
                    widget.user, textEditingController.text, Type.text);
                textEditingController.clear();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
