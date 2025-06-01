import 'dart:io';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';

Widget buildImage(
  EventModel event, {
  double height = 200,
  double width = double.infinity,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
}) {
  final imageWidget =
      event.localImagePath != null && File(event.localImagePath!).existsSync()
          ? Image.file(
              File(event.localImagePath!),
              height: height,
              width: width,
              fit: fit,
            )
          : Image.network(
              event.imageUrl,
              height: height,
              width: width,
              fit: fit,
            );

  if (borderRadius != null) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageWidget,
    );
  } else {
    return imageWidget;
  }
}
