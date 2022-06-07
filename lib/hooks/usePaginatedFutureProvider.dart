import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hookified_infinite_scroll_pagination/hookified_infinite_scroll_pagination.dart';

PagingController<P, ItemType> usePaginatedFutureProvider<T, P, ItemType>(
  FutureProvider<T> Function(P pageKey) createSnapshot, {
  required P firstPageKey,
  required WidgetRef ref,
  void Function(
    T,
    PagingController<P, ItemType> pagingController,
    P pageKey,
  )?
      onData,
  void Function(Object)? onError,
  void Function()? onLoading,
}) {
  final currentPageKey = useState(firstPageKey);
  final snapshot = ref.watch(createSnapshot(currentPageKey.value));
  final pagingController = usePagingController<P, ItemType>(
      firstPageKey: firstPageKey,
      onPageRequest: (pageKey, pagingController) {
        if (currentPageKey.value != pageKey) {
          currentPageKey.value = pageKey;
        }
      });

  useEffect(() {
    snapshot.whenOrNull(
      data: (data) =>
          onData?.call(data, pagingController, currentPageKey.value),
      error: (error, _) {
        pagingController.error = error;
        return onError?.call(error);
      },
      loading: onLoading,
    );
    return null;
  }, [currentPageKey, snapshot]);

  return pagingController;
}
