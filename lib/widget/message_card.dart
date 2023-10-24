import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/modal/message_model.dart';
import 'package:chat_app/utils/helper/date_utils.dart';
import 'package:chat_app/utils/helper/firestore_core_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class message_Card extends StatefulWidget {
  final Message message;
  const message_Card({Key? key, required this.message}) : super(key: key);

  @override
  State<message_Card> createState() => _message_CardState();
}

class _message_CardState extends State<message_Card> {
  @override
  Widget build(BuildContext context) {
    return FireStoreHelper.user.uid == widget.message.fromId
        ?greenMessage()
        :blueMessage();
  }

  Widget greenMessage(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width:  Get.width * 0.02,
            ),
            if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all),
            SizedBox(
              width:  Get.width * 0.02,
            ),
            Padding(
              padding:  EdgeInsets.only(
                right: Get.width * 0.04,
              ),
              child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(
                  color: Colors.black54
              ),),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? Get.width * .03
                : Get.width * .04),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Get.width * 0.025),
                  topRight: Radius.circular(Get.width * 0.025),
                  bottomLeft: Radius.circular(Get.width * 0.025),
                ),
                border: Border.all(
                  color: Colors.green,
                )
            ),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.height * 0.01
            ),
            child: widget.message.type == Type.text
                ?
            //show text
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                :
            //show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget blueMessage(){
    if (widget.message.read.isEmpty) {
      FireStoreHelper.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? Get.width * .03
                : Get.width * .04),
            decoration: BoxDecoration(
              color: Color.fromARGB(225, 221, 245, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Get.width * 0.025),
                topRight: Radius.circular(Get.width * 0.025),
                bottomRight: Radius.circular(Get.width * 0.025),
              ),
              border: Border.all(
                color: Colors.blue,
              )
            ),
            margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04,
              vertical: Get.height * 0.01
            ),
            child:  widget.message.type == Type.text
                ?
            //show text
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                :
            //show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
              ),
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(
            right: Get.width * 0.04,
          ),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(
              color: Colors.black54
          ),),
        ),
      ],
    );
  }
}
