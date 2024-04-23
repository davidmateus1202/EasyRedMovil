import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar los datos',
                style: TextStyle(
                    color: HexColor('9A0EE2'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                'assets/images/loading.gif',
                height: 50,
                width: 50,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return data['userUid'] == Provider.of<AuthenticationServices>(context, listen: false).getUserUid
                    ? Card(
                        child: Container(
                          child: Column(
                            children: [
                              Text(data['username'] ?? ''),
                              Text(data['userUid'] ?? ''),
                              Text(data['content'] ?? ''),
                              Text(data['time'].toString() ?? ''),
                              Image.network(data['postImageUrl'] ?? ''),
                            ],
                          ),
                        ))
                    : Container();
              }).toList(),
            ),
          );
        });
  }
}

class Authentication {
}
