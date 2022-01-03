import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrackButton extends StatefulWidget {
  final String index;
  final String trackName;
  final List<String> artists;
  final String album;
  final String playback_time;
  final String? thumbnail_url;
  final void Function()? onTap;
  TrackButton({
    required this.index,
    required this.trackName,
    required this.artists,
    required this.album,
    required this.playback_time,
    this.thumbnail_url,
    this.onTap,
  });

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onTap,
        child: Ink(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.index,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 15),
                  if (widget.thumbnail_url != null)
                    CachedNetworkImage(
                      imageUrl: widget.thumbnail_url!,
                      maxHeightDiskCache: 50,
                      maxWidthDiskCache: 50,
                    ),
                  SizedBox(width: 15),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trackName,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(widget.artists.join(", "))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Text(widget.album),
              SizedBox(width: 15),
              Text(widget.playback_time)
            ],
          ),
        ),
      ),
    );
  }
}
