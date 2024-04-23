import 'package:easyred/Firebase/FirebasePost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
              Provider.of<FirebasePost>(context, listen: false)
                  .initPostData(context);
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
            onPressed: () {},
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
