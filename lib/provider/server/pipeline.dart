import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelf/shelf.dart';

final pipelineProvider = Provider((ref) {
  const pipeline = Pipeline();
  if (kDebugMode) {
    pipeline.addMiddleware(logRequests());
  }
  return pipeline;
});
