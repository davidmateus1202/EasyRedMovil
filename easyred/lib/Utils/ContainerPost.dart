import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyred/Firebase/Authentication.dart';
import 'package:easyred/Firebase/FirebasePost.dart';
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerPost extends StatelessWidget {
  ContainerPost({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;
  final GlobalKey<FormFieldState> _formKeyComment = GlobalKey<FormFieldState>();
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(data['userImage'] ?? ''),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          children: [
                            Text(
                              data['username'] ?? '',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                                Timestamp.fromDate(data['time'].toDate())
                                    .toDate()
                                    .toString()
                                    .substring(0, 10),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12)),
                          ],
                        )),
                  ],
                ),
                Provider.of<AuthenticationServices>(context, listen: false)
                            .getUserUid ==
                        data['userUid']
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          onPressed: () async {
                            await Provider.of<FirebasePost>(context,
                                    listen: false)
                                .ObtenerIdPostDelete(data['postId']);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 12, bottom: 24),
                  child: Text(
                    data['content'] ?? '',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 15),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign
                        .left, // Agrega este overflow para manejar texto largo
                  ),
                ),
              ),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  data['postImageUrl'] ?? '',
                  fit: BoxFit.cover,
                  scale: 0.5,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {},
                  icon: Icon(Icons.comment),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    key: _formKeyComment,
                    onChanged: (value) {
                      _formKeyComment.currentState?.validate();
                    },
                    controller: TextEditingController(),
                    maxLines: null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.forum, color: Colors.grey[300],),
                      hintText: 'Write a comment',
                      hintStyle: TextStyle(
                        
                        fontFamily: 'Poppins',
                        fontSize: 12
                      ),
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    )),
                    validator: (value) {
                      if(value!.isEmpty || value == null) {
                        return 'Please enter a comment';
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {

                    // add funcion to comment
                    if(_formKeyComment.currentState!.validate()) {
                      Provider.of<FirebasePost>(context, listen: false).Comment(context, data['postId'], commentController.text);
                    }
                  },
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
