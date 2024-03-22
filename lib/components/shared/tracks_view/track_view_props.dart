import 'dart:async';

import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:spotify/spotify.dart';

class PaginationProps {
  final bool hasNextPage;
  final bool isLoading;
  final VoidCallback onFetchMore;
  final Future<void> Function() onRefresh;
  final Future<List<Track>> Function() onFetchAll;

  const PaginationProps({
    required this.hasNextPage,
    required this.isLoading,
    required this.onFetchMore,
    required this.onFetchAll,
    required this.onRefresh,
  });

  factory PaginationProps.fromQuery(
    InfiniteQuery<List<Track>, dynamic, int> query, {
    required Future<List<Track>> Function() onFetchAll,
  }) {
    return PaginationProps(
      hasNextPage: query.hasNextPage,
      isLoading: query.isLoadingNextPage,
      onFetchMore: query.fetchNext,
      onFetchAll: onFetchAll,
      onRefresh: query.refreshAll,
    );
  }

  @override
  operator ==(Object other) {
    return other is PaginationProps &&
        other.hasNextPage == hasNextPage &&
        other.isLoading == isLoading &&
        other.onFetchMore == onFetchMore &&
        other.onFetchAll == onFetchAll &&
        other.onRefresh == onRefresh;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      hasNextPage.hashCode ^
      isLoading.hashCode ^
      onFetchMore.hashCode ^
      onFetchAll.hashCode ^
      onRefresh.hashCode;
}

class InheritedTrackView extends InheritedWidget {
  final String collectionId;
  final String title;
  final String? description;
  final String image;
  final String routePath;
  final List<Track> tracks;
  final PaginationProps pagination;
  final bool isLiked;
  final String shareUrl;

  // events
  final FutureOr<bool?> Function()? onHeart; // if null heart button will hidden

  const InheritedTrackView({
    super.key,
    required super.child,
    required this.collectionId,
    required this.title,
    this.description,
    required this.image,
    required this.tracks,
    required this.pagination,
    required this.routePath,
    required this.shareUrl,
    this.isLiked = false,
    this.onHeart,
  });

  @override
  bool updateShouldNotify(InheritedTrackView oldWidget) {
    return oldWidget.title != title ||
        oldWidget.description != description ||
        oldWidget.image != image ||
        oldWidget.tracks != tracks ||
        oldWidget.pagination != pagination ||
        oldWidget.isLiked != isLiked ||
        oldWidget.onHeart != onHeart ||
        oldWidget.shareUrl != shareUrl ||
        oldWidget.routePath != routePath ||
        oldWidget.collectionId != collectionId ||
        oldWidget.child != child;
  }

  static InheritedTrackView of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<InheritedTrackView>();
    if (widget == null) {
      throw Exception(
        'InheritedTrackView not found. Make sure to wrap [TrackView] with [InheritedTrackView]',
      );
    }
    return widget;
  }
}
