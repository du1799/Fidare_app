import 'package:flutter/material.dart';

CircleAvatar circleAvatar(String url) {
  return (Uri.tryParse(url)!.isAbsolute)
      ? CircleAvatar(
          backgroundImage: NetworkImage(url),
          radius: null,
        )
      : CircleAvatar(
          child: Icon(Icons.person),
        );
}
