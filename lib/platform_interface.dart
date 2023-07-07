import 'package:flutter/widgets.dart';
import 'package:flutter_pagecall/flutter_pagecall.dart';

abstract class PlatformPagecallView {
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required String viewType,
    required void Function(int id) onPlatformViewCreated,
  });
}
