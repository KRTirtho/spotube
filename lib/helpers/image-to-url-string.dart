import 'package:spotify/spotify.dart';

String imageToUrlString(List<Image>? images, {int index = 0}) {
  return images != null && images.isNotEmpty
      ? images[0].url!
      : "https://avatars.dicebear.com/api/croodles-neutral/${DateTime.now().toString()}.png";
}
