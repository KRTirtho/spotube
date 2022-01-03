import 'dart:convert';

class YtSearchResult {
  String? id;
  String? title;
  String? duration;
  String? thumbnail;
  YtChannel? channel;
  String? uploadDate;
  String? viewCount;
  String? type;

  YtSearchResult(
      {this.id,
      this.title,
      this.duration,
      this.thumbnail,
      this.channel,
      this.uploadDate,
      this.viewCount,
      this.type});

  YtSearchResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    thumbnail = json['thumbnail'];
    channel = json['channel'] != null
        ? new YtChannel.fromJson(json['channel'])
        : null;
    uploadDate = json['uploadDate'];
    viewCount = json['viewCount'];
    type = json['type'];
  }

  String toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['thumbnail'] = this.thumbnail;
    if (this.channel != null) {
      data['channel'] = this.channel?.toJson();
    }
    data['uploadDate'] = this.uploadDate;
    data['viewCount'] = this.viewCount;
    data['type'] = this.type;
    return jsonEncode(data);
  }
}

class YtChannel {
  String? id;
  String? name;
  String? url;

  YtChannel({this.id, this.name, this.url});

  YtChannel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
