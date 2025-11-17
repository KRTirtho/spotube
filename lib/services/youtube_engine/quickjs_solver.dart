// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:youtube_explode_dart/js_challenge.dart';
// // ignore: implementation_imports
// import 'package:youtube_explode_dart/src/reverse_engineering/challenges/ejs/ejs.dart';
// import 'package:jsf/jsf.dart';

// /// [WIP]
// class QuickJSEJSSolver extends BaseJSChallengeSolver {
//   final _playerCache = <String, String>{};
//   final _sigCache = <(String, String, JSChallengeType), String>{};
//   final QuickJSRuntime qjs;
//   QuickJSEJSSolver._(this.qjs);

//   static Future<QuickJSEJSSolver> init() async {
//     final modules = await EJSBuilder.getJSModules();
//     final deno = await QuickJSRuntime.init(modules);
//     return QuickJSEJSSolver._(deno);
//   }

//   @override
//   Future<String> solve(
//       String playerUrl, JSChallengeType type, String challenge) async {
//     final key = (playerUrl, challenge, type);
//     if (_sigCache.containsKey(key)) {
//       return _sigCache[key]!;
//     }

//     var playerScript = _playerCache[playerUrl];
//     if (playerScript == null) {
//       final resp = await http.get(Uri.parse(playerUrl));
//       playerScript = _playerCache[playerUrl] = resp.body;
//     }
//     final jsCall = EJSBuilder.buildJSCall(playerScript, {
//       type: [challenge],
//     });

//     final result = await qjs.eval(jsCall);
//     // Trim the first and last characters (' delimiters of the JS string)
//     final data = json.decode(result.substring(1, result.length - 1))
//         as Map<String, dynamic>;

//     if (data['type'] != 'result') {
//       throw Exception('Unexpected response type: ${data['type']}');
//     }
//     final response = data['responses'][0];
//     if (response['type'] != 'result') {
//       throw Exception('Unexpected item response type: ${response['type']}');
//     }
//     final decoded = response['data'][challenge];
//     if (decoded == null) {
//       throw Exception('No data for challenge: $challenge');
//     }

//     _sigCache[key] = decoded;

//     return decoded;
//   }

//   @override
//   void dispose() {
//     qjs.dispose();
//   }
// }

// class _EvalRequest {
//   final String code;
//   final Completer<String> completer;

//   _EvalRequest(this.code, this.completer);
// }

// class QuickJSRuntime {
//   final JsRuntime _runtime;
//   final StreamController<String> _stdoutController =
//       StreamController.broadcast();

//   // Queue for incoming eval requests
//   final Queue<_EvalRequest> _evalQueue = Queue<_EvalRequest>();
//   bool _isProcessing = false; // Flag to indicate if an eval is currently active

//   QuickJSRuntime(this._runtime);

//   /// Disposes the Deno process.
//   void dispose() {
//     _stdoutController.close();
//     _runtime.dispose();
//   }

//   /// Sends JavaScript code to Deno for evaluation.
//   /// Assumes single-line input produces single-line output.
//   Future<String> eval(String code) {
//     final completer = Completer<String>();
//     final request = _EvalRequest(code, completer);
//     _evalQueue.addLast(request); // Add request to the end of the queue
//     _processQueue(); // Attempt to process the queue

//     return completer.future;
//   }

//   // Processes the eval queue.
//   void _processQueue() {
//     if (_isProcessing || _evalQueue.isEmpty) {
//       return; // Already processing or nothing in queue
//     }

//     _isProcessing = true;
//     final request =
//         _evalQueue.first; // Get the next request without removing it yet

//     StreamSubscription? currentOutputSubscription;
//     Completer<void> lineReceived = Completer<void>();

//     currentOutputSubscription = _stdoutController.stream.listen((data) {
//       if (!lineReceived.isCompleted) {
//         // Assuming single line output per eval.
//         // This will capture the first full line or chunk received after sending the code.
//         request.completer.complete(data.trim());
//         lineReceived.complete();
//         currentOutputSubscription
//             ?.cancel(); // Cancel subscription for this request
//         _evalQueue.removeFirst(); // Remove the processed request
//         _isProcessing = false; // Mark as no longer processing
//         _processQueue(); // Attempt to process next item in queue
//       }
//     }, onError: (e) {
//       if (!request.completer.isCompleted) {
//         request.completer.completeError(e);
//         lineReceived.completeError(e);
//         currentOutputSubscription?.cancel();
//         _evalQueue.removeFirst();
//         _isProcessing = false;
//         _processQueue();
//       }
//     }, onDone: () {
//       if (!request.completer.isCompleted) {
//         request.completer.completeError(
//             StateError('Deno process closed while awaiting eval result.'));
//         lineReceived.completeError(
//             StateError('Deno process closed while awaiting eval result.'));
//         currentOutputSubscription?.cancel();
//         _evalQueue.removeFirst();
//         _isProcessing = false;
//         _processQueue();
//       }
//     });

//     debugPrint("[QuickJS Solver] Evaluate ${request.code}");
//     final result = _runtime.eval(request.code);
//     debugPrint("[QuickJS Solver] Evaluation Result $result");
//     _stdoutController.add(result);
//   }

//   static Future<QuickJSRuntime> init(String initCode) async {
//     debugPrint("[QuickJS Solver] Initializing");
//     debugPrint("[QuickJS Solver] script $initCode");

//     final runtime = JsRuntime();

//     runtime.execInitScript(initCode);

//     return QuickJSRuntime(runtime);
//   }
// }
