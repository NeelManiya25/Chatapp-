import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/modal/chat_user_model.dart';
import 'package:chat_app/modal/message_model.dart';
import 'package:chat_app/screens/views/chat_Screen.dart';
import 'package:chat_app/utils/helper/firestore_core_helper.dart';
import 'package:chat_app/widget/profile_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/helper/date_utils.dart';

class chatUser_Card extends StatefulWidget {
  final ChatUser user;

  const chatUser_Card({Key? key, required this.user}) : super(key: key);

  @override
  State<chatUser_Card> createState() => _chatUser_CardState();
}

class _chatUser_CardState extends State<chatUser_Card> {

  Message? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Card(
        // color: ,
        elevation: 1,
        child: InkWell(
          onTap: () {
            Get.to(
              chat_Screen(
                user: widget.user,
              ),
            );
          },
          child: StreamBuilder(
            stream: FireStoreHelper.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) message = list[0];

              return ListTile(
                //user profile picture
                leading: InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) => profile_Dialog(user:  widget.user),);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Get.height * .03),
                    child: CachedNetworkImage(
                      width: Get.height * .055,
                      height: Get.height * .055,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),

                //user name
                title: Text(widget.user.name),

                //last message
                subtitle:Text(
                    message != null
                        ? message!.type == Type.image
                        ? 'image'
                        : message!.msg
                        : widget.user.about,
                    maxLines: 1),

                //last message time
                trailing: message == null
                    ? null //show nothing when no message is sent
                    : message!.read.isEmpty &&
                    message!.fromId != FireStoreHelper.user.uid
                    ?
                //show for unread message
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(10)),
                )
                    :
                //message sent time
                Text(
                  MyDateUtil.getLastMessageTime(
                      context: context, time: message!.sent),
                  style: const TextStyle(color: Colors.black54),
                ),
              );
            },
          )),
        ),
    );
  }
}
