import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MovieCard extends StatelessWidget {

  final DocumentSnapshot snapshot;
  final Function onEdit;
  const MovieCard({Key key,this.snapshot,this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 170,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                      imageUrl: snapshot.data['image'],
                      height: 170,width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundColor: Colors.white,child: IconButton(icon: Icon(Icons.edit), onPressed: onEdit),),
                  )
                ),
              ],
            )),
        ListTile(title: Text("${snapshot.data['name']}",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Avenir", fontSize: 20)),
          subtitle: Text("${snapshot.data['director']}"),
          trailing: IconButton(icon: Icon(Icons.delete_outline), onPressed: () async {
            await snapshot.reference.delete();
          }),
        ),
      ],
    ),);
  }
}
