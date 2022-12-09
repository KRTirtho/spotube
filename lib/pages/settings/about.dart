import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/hooks/use_package_info.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutSpotube extends HookConsumerWidget {
  const AboutSpotube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final packageInfo = usePackageInfo();

    return PlatformScaffold(
      appBar: PageWindowTitleBar(
        leading: const PlatformBackButton(),
        title: const PlatformText("About Wives"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Image.asset(
                "assets/spotube-logo.png",
                height: 200,
                width: 200,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlatformText.headline(
                      "Spotube, a light-weight, cross-platform, free-for-all spotify client",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PlatformText.subheading(
                          "Founder:   Kingkor Roy Tirtho",
                        ),
                        const SizedBox(width: 5),
                        CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.network(
                              "https://avatars.githubusercontent.com/u/61944859?v=4",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    PlatformText(
                      "Version:              v${packageInfo.version}",
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          "https://github.com/KRTirtho/spotube",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const PlatformText(
                        "Repository:        https://github.com/KRTirtho/spotube",
                      ),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          "https://raw.githubusercontent.com/KRTirtho/spotube/main/LICENSE",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const PlatformText(
                        "License:               BSD-4-Clause",
                      ),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          "https://github.com/KRTirtho/spotube/issues",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const PlatformText(
                        "Bugs+Issues:     https://github.com/KRTirtho/spotube/issues",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                runSpacing: 20,
                spacing: 20,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse("https://www.buymeacoffee.com/krtirtho"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SvgPicture.network(
                        "https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=krtirtho&button_colour=FF5F5F&font_colour=ffffff&font_family=Inter&outline_colour=000000&coffee_colour=FFDD00",
                        height: 45,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse(
                            "https://opencollective.com/spotube",
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Image.network(
                        "https://opencollective.com/spotube/donate/button.png?color=blue",
                        height: 45,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse("https://patreon.com/krtirtho"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Image.network(
                        "https://user-images.githubusercontent.com/61944859/180249027-678b01b8-c336-451e-b147-6d84a5b9d0e7.png",
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PlatformText.caption(
                "Made with ❤️ in Bangladesh🇧🇩",
                textAlign: TextAlign.center,
              ),
              PlatformText.caption(
                "© 2021-${DateTime.now().year} Kingkor Roy Tirtho",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: PlatformText.caption(
                  licenseText,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const licenseText = """
BSD-4-Clause License

Copyright (c) 2022 Kingkor Roy Tirtho. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software must display the following acknowledgement:
This product includes software developed by Kingkor Roy Tirtho.
4. Neither the name of the Software nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY KINGKOR ROY TIRTHO AND CONTRIBUTORS  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL KINGKOR ROY TIRTHO AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
""";
