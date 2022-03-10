import 'package:spotify/spotify.dart';
import 'package:uuid/uuid.dart' show Uuid;

const uuid = Uuid();
String imageToUrlString(List<Image>? images, {int index = 0}) {
  return images != null && images.isNotEmpty
      ? images[0].url!
      : "https://avatars.dicebear.com/api/bottts/${uuid.v4()}.png";
}
