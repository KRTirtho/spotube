import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

void main() async {
  final client = PubClient();

  final pubspec = Pubspec.parse(File('pubspec.yaml').readAsStringSync());

  final allDeps = [
    ...pubspec.dependencies.entries,
    ...pubspec.devDependencies.entries,
  ];

  final dependencies = allDeps
      .where((d) => d.value is HostedDependency)
      .map((d) => d.key)
      .toSet();
  final packageInfo = await Future.wait(dependencies.map(client.packageInfo));

  final gitDepsList = List.castFrom<MapEntry<String, Dependency>,
      MapEntry<String, GitDependency>>(
    allDeps
        .where((d) => d.value is GitDependency)
        .map((d) => MapEntry(d.key, d.value as GitDependency))
        .toList(),
  );

  final gitDeps = gitDepsList.map(
    (d) {
      final uri = Uri.parse(
        d.value.url.toString().replaceAll('.git', ''),
      );
      return MapEntry(
        d.key,
        uri.replace(
          pathSegments: [
            ...uri.pathSegments,
            'raw',
            d.value.ref ?? 'main',
            d.value.path ?? '',
            'pubspec.yaml',
          ],
        ).toString(),
      );
    },
  ).toList();

  final gitPubspecs = await Future.wait(
    gitDeps.map(
      (d) {
        Pubspec parser(res) {
          try {
            return Pubspec.parse(res.body);
          } catch (e) {
            final document = parse(res.body);
            final pre = document.querySelector('pre');
            if (pre == null) {
              log(d.toString());
              rethrow;
            }
            return Pubspec.parse(pre.text);
          }
        }

        return get(Uri.parse(d.value)).then(parser).catchError(
              (_) => get(Uri.parse(d.value.replaceFirst('/main', '/master')))
                  .then(parser),
            );
      },
    ),
  );

  // ignore: avoid_print
  print(
    packageInfo
        .map(
          (package) =>
              '1. [${package.name}](${package.latestPubspec.homepage ?? package.url}) - ${package.description.replaceAll('\n', '')}',
        )
        .join('\n'),
  );
  // ignore: avoid_print
  print(
    gitPubspecs.map(
      (package) {
        final packageUrl = package.homepage ??
            gitDepsList
                .firstWhereOrNull((dep) => dep.key == package.name)
                ?.value
                .url
                .toString();
        return '1. [${package.name}]($packageUrl) - ${package.description?.replaceAll('\n', '')}';
      },
    ).join('\n'),
  );
  exit(0);
}
