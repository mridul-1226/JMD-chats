import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.video ? VideoPlayerItem(videoUrl: message) : CachedNetworkImage(
            imageUrl: message,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.cover);
  }
}
