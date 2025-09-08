import 'package:flutter/gestures.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/artist/wikipedia.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ArtistPageFooter extends ConsumerWidget {
  final SpotubeFullArtistObject artist;
  const ArtistPageFooter({super.key, required this.artist});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:typography) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final artistImage = artist.images.asUrlString(
      placeholder: ImagePlaceholder.artist,
    );
    final summary = ref.watch(artistWikipediaSummaryProvider(artist));
    if (summary.asData?.value == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: mediaQuery.smAndDown
          ? const EdgeInsets.all(20)
          : const EdgeInsets.all(30),
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
          image: UniversalImage.imageProvider(
            summary.asData?.value!.thumbnail?.source_ ?? artistImage,
            height: summary.asData?.value!.thumbnail?.height.toDouble(),
            width: summary.asData?.value!.thumbnail?.width.toDouble(),
          ),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: typography.semiBold.copyWith(
            color: Colors.white,
          ),
          children: [
            // icon
            const WidgetSpan(
              child: Icon(
                SpotubeIcons.wikipedia,
                color: Colors.white,
                size: 30,
              ),
            ),
            TextSpan(
              text: " Wikipedia",
              style: typography.large.copyWith(
                color: Colors.white,
              ),
            ),
            const TextSpan(text: '\n\n'),
            TextSpan(
              text: summary.asData?.value!.extract,
            ),
            TextSpan(
              text: '\n...read more at wikipedia',
              style: typography.semiBold.copyWith(
                color: Colors.sky[300],
                decoration: TextDecoration.underline,
                decorationColor: Colors.sky[300],
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrlString(
                    "http://en.wikipedia.org/wiki?curid=${summary.asData?.value?.pageid}",
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
