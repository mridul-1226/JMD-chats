import 'package:chatting_app/data/colors.dart';
import 'package:chatting_app/data/info.dart';
import 'package:flutter/material.dart';

class WebCharAppBar extends StatelessWidget {
  const WebCharAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: webAppBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1419974913260232732/Cy_CUavB.jpg'),
                radius: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(info[6]['name'].toString()),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}