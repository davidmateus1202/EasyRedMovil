import 'package:easyred/Pages/Home/ChatRoom/ChatPage.dart';
import 'package:easyred/Pages/Home/Feed/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class Container_Buttons extends StatelessWidget {
  const Container_Buttons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/4.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: PostPage()));
            },
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color?>(
                Color.fromARGB(0, 212, 174, 174),
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/5.jpeg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: ChatPage()));
            },
            child: Text(
              'Message',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color?>(
                Color.fromARGB(0, 212, 174, 174),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
