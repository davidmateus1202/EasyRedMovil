import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

Future CommentsContainer(BuildContext context, String postId) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Post')
                .doc(postId)
                .collection('Comments')
                .orderBy('time', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(data['userImage']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    children: [
                                      Text(
                                        data['username'],
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                      Text(
                                          Timestamp.fromDate(
                                                  data['time'].toDate())
                                              .toDate()
                                              .toString()
                                              .substring(0, 10),
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 8)),
                                    
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
                              child: Text(
                                data['comment'],
                                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal, fontSize: 12),
                                maxLines: null,
                              ),
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width*0.85,
                            child: Divider(
                              thickness: 1,
                              color: HexColor('9A0EE2'),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            });
      });
}
