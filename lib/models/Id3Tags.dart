import 'package:dart_tags/dart_tags.dart';

class Id3Tags {
  Id3Tags({
    this.tsse,
    this.title,
    this.album,
    this.tpe2,
    this.comment,
    this.tcop,
    this.tdrc,
    this.genre,
    this.picture,
  });

  String? tsse;
  String? title;
  String? album;
  String? tpe2;
  Comment? comment;
  String? tcop;
  String? tdrc;
  String? genre;
  AttachedPicture? picture;

  factory Id3Tags.fromJson(Map<String, dynamic> json) => Id3Tags(
        tsse: json["TSSE"],
        title: json["title"],
        album: json["album"],
        tpe2: json["TPE2"],
        comment: json["comment"]?["eng:"] is Comment
            ? json["comment"]["eng:"]
            : CommentJson.fromJson(Map.from(
                json["comment"]?["eng:"] ?? {},
              )),
        tcop: json["TCOP"],
        tdrc: json["TDRC"],
        genre: json["genre"],
        picture: json["picture"]?["Cover (front)"] is AttachedPicture
            ? json["picture"]["Cover (front)"]
            : AttachedPictureJson.fromJson(Map.from(
                json["picture"]?["Cover (front)"] ?? {},
              )),
      );

  factory Id3Tags.fromId3v1Tags(Id3v1Tags v1tags) => Id3Tags(
        album: v1tags.album,
        comment: Comment("", "", v1tags.comment ?? ""),
        genre: v1tags.genre,
        title: v1tags.title,
        tcop: v1tags.year,
        tdrc: v1tags.year,
        tpe2: v1tags.artist,
      );

  Map<String, dynamic> toJson() => {
        "TSSE": tsse,
        "title": title,
        "album": album,
        "TPE2": tpe2,
        "comment": comment,
        "TCOP": tcop,
        "TDRC": tdrc,
        "genre": genre,
        "picture": picture,
      };
}

extension CommentJson on Comment {
  static fromJson(Map<String, dynamic> json) => Comment(
        json["lang"] ?? "",
        json["description"] ?? "",
        json["comment"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "description": description,
        "key": key,
        "lang": lang,
      };
}

extension AttachedPictureJson on AttachedPicture {
  static fromJson(Map<String, dynamic> json) => AttachedPicture(
        json["mime"] ?? "",
        json["imageTypeCode"] ?? 0,
        json["description"] ?? "",
        List<int>.from(json["imageData"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "imageData": imageData,
        "imageData64": imageData64,
        "imageType": imageType,
        "imageTypeCode": imageTypeCode,
        "key": key,
        "mime": mime,
      };
}

class Id3v1Tags {
  String? title;
  String? artist;
  String? album;
  String? year;
  String? comment;
  String? track;
  String? genre;

  Id3v1Tags({
    this.title,
    this.artist,
    this.album,
    this.year,
    this.comment,
    this.track,
    this.genre,
  });

  Id3v1Tags.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    artist = json['artist'];
    album = json['album'];
    year = json['year'];
    comment = json['comment'];
    track = json['track'];
    genre = json['genre'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'year': year,
      'comment': comment,
      'track': track,
      'genre': genre,
    };
  }
}
