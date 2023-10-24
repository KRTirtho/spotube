import 'dart:io';

import 'package:collection/collection.dart';

Future<Map<String, String>> get buildProps async {
  try {
    final getProp = await Process.run('getprop', []);
    return Map.fromEntries(
      getProp.stdout
          .toString()
          .split('\n')
          .where((x) => x.startsWith('[') && x.endsWith(']'))
          .map((e) => e.replaceAll(RegExp(r'(^\[|\]$)'), '').split(']: ['))
          .map((x) => MapEntry(x.first, x.last))
          .where((x) => x.value.isNotEmpty),
    );
  } catch (e, s) {
    return {};
  }
}

bool isBuggyOs(Map<String, String> props) {
  final brand = [
    'ro.product.brand',
    'ro.product.system.brand',
    'ro.product.system_ext.brand',
    'ro.product.vendor.brand',
  ].map((x) => props[x]?.toLowerCase()).whereNotNull();
  final oppo = ['oppo', 'oplus', 'oneplus', 'realme'];

  return oppo.any(brand.contains);
}
