import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

class CreditsCommand extends Command {
  final dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
    ),
  );

  @override
  String get description => "Generate credits for used Library's authors";

  @override
  String get name => "credits";

  @override
  run() async {
    final client = PubClient();
    final cwd = Directory.current;

    final pubspec = Pubspec.parse(
      File(join(cwd.path, 'pubspec.yaml')).readAsStringSync(),
    );

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
          Pubspec parser(Response res) {
            try {
              return Pubspec.parse(res.data);
            } catch (e) {
              final document = parse(res.data);
              final pre = document.querySelector('pre');
              if (pre == null) {
                stdout.writeln(d.toString());
                rethrow;
              }
              return Pubspec.parse(pre.text);
            }
          }

          return dio.get(d.value).then(parser).catchError(
                (_) => dio
                    .get(d.value.replaceFirst('/main', '/master'))
                    .then(parser),
              );
        },
      ),
    );

    stdout.writeln(
      packageInfo
          .map(
            (package) =>
                '1. [${package.name}](${package.latestPubspec.homepage ?? package.url}) - ${package.description.replaceAll('\n', '')}',
          )
          .join('\n'),
    );

    stdout.writeln(
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
  }
}
