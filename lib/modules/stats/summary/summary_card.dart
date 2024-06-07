import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spotube/collections/formatters.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String unit;
  final String description;
  final VoidCallback? onTap;

  final MaterialColor color;

  SummaryCard({
    super.key,
    required double title,
    required this.unit,
    required this.description,
    required this.color,
    this.onTap,
  }) : title = compactNumberFormatter.format(title);

  const SummaryCard.unformatted({
    super.key,
    required this.title,
    required this.unit,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData(:textTheme, :brightness) = Theme.of(context);

    final descriptionNewLines = description.split("").where((s) => s == "\n");

    return Card(
      color: brightness == Brightness.dark ? color.shade100 : color.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: textTheme.headlineLarge?.copyWith(
                        color: color.shade900,
                      ),
                    ),
                    TextSpan(
                      text: " $unit",
                      style: textTheme.titleMedium?.copyWith(
                        color: color.shade900,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
              const Gap(5),
              AutoSizeText(
                description,
                maxLines: description.contains("\n")
                    ? descriptionNewLines.length + 1
                    : 1,
                minFontSize: 9,
                style: textTheme.labelMedium!.copyWith(
                  color: color.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
