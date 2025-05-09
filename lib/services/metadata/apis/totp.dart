import 'package:flutter_js/javascript_runtime.dart';
import 'package:otp_util/otp_util.dart';
// ignore: implementation_imports
import 'package:otp_util/src/utils/generic_util.dart';

class PluginTotpGenerator {
  final JavascriptRuntime runtime;

  PluginTotpGenerator(this.runtime) {
    runtime.onMessage("TotpGenerator.generate", (args) {
      final opts = args[0];
      if (opts is! Map) {
        return;
      }

      final totp = TOTP(
        secret: opts["secret"] as String,
        algorithm: OTPAlgorithm.values.firstWhere(
          (e) => e.name == opts["algorithm"],
          orElse: () => OTPAlgorithm.SHA1,
        ),
        digits: opts["digits"] as int? ?? 6,
        interval: opts["interval"] as int? ?? 30,
      );

      final otp = totp.generateOTP(
        input: Util.timeFormat(
          time: DateTime.fromMillisecondsSinceEpoch(opts["period"]),
          interval: 30,
        ),
      );

      runtime.evaluate(
        """
        eventEmitter.emit('TotpGenerator.generate', '$otp');
        """,
      );
    });
  }
}
