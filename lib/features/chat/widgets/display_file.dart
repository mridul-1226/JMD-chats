import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/common/enums/message_enum.dart';
import 'package:chatting_app/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();
    bool isPlaying = false;
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 18),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : type == MessageEnum.audio
                ? StatefulBuilder(
                    builder: (context, setState) => IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          audioPlayer.play(
                            UrlSource(message),
                            volume: 1,
                          );
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 30,
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: message,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.cover);
  }
}
