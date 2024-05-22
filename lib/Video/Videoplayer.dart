// import 'package:flutter/material.dart';

// class VideoPlayer extends StatelessWidget {
//   const VideoPlayer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
class VideoModel {
  String name = ' ', thumbnail = ' ', mediaurl = ' ';
  VideoModel(this.name, this.thumbnail, this.mediaurl);
  VideoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    thumbnail = json['thumbnail'];
    mediaurl = json['mediaurl'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['thumbnail'] = this.thumbnail;
    data['mediaurl'] = this.mediaurl;
    return data;
  }
}
