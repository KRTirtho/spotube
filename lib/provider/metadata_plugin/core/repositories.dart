import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';
import 'package:spotube/services/dio/dio.dart';

class MetadataPluginRepositoriesNotifier
    extends PaginatedAsyncNotifier<MetadataPluginRepository> {
  MetadataPluginRepositoriesNotifier() : super();

  Map<String, bool> _hasMore = {};

  @override
  fetch(int offset, int limit) async {
    final gitubSearch = globalDio.get(
      "https://api.github.com/search/repositories",
      queryParameters: {
        "q": "topic:spotube-plugin",
        "sort": "stars",
        "order": "desc",
        "page": offset,
        "per_page": limit,
      },
    );

    final codebergSearch = globalDio.get(
      "https://codeberg.org/api/v1/repos/search",
      queryParameters: {
        "q": "spotube-plugin",
        "topic": "true",
        "sort": "stars",
        "order": "desc",
        "page": offset,
        "limit": limit,
      },
    );

    final responses = await Future.wait([
      if (_hasMore["github.com"] ?? true) gitubSearch,
      if (_hasMore["codeberg.org"] ?? true) codebergSearch,
    ]);

    final repos = responses
        .expand(
      (response) => response.data["data"] ?? response.data["items"] ?? [],
    )
        .map((repo) {
      return MetadataPluginRepository(
        name: repo["name"] ?? "",
        owner: repo["owner"]["login"] ?? "",
        description: repo["description"] ?? "",
        repoUrl: repo["html_url"] ?? "",
        topics: repo["topics"].cast<String>() ?? [],
      );
    }).toList();

    final hasMore = responses.any((response) {
      final items =
          (response.data["data"] ?? response.data["items"] ?? []) as List;
      _hasMore[response.requestOptions.uri.host] =
          items.length >= limit && items.isNotEmpty;

      return _hasMore[response.requestOptions.uri.host] ?? false;
    });

    return SpotubePaginationResponseObject(
      items: repos,
      total: responses.fold<int>(
        0,
        (previousValue, response) => previousValue +
            (response.data["total_count"] ??
                int.tryParse(response.headers["x-total-count"]?[0] ?? "") ??
                0) as int,
      ),
      hasMore: hasMore,
      nextOffset: hasMore ? offset + 1 : null,
      limit: limit,
    );
  }

  @override
  build() async {
    return await fetch(0, 10);
  }
}

final metadataPluginRepositoriesProvider = AsyncNotifierProvider<
    MetadataPluginRepositoriesNotifier,
    SpotubePaginationResponseObject<MetadataPluginRepository>>(
  () => MetadataPluginRepositoriesNotifier(),
);
