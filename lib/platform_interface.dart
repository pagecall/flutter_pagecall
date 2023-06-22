import 'package:flutter/widgets.dart';
import 'package:pagecall_flutter/pagecall_flutter.dart';

abstract class PlatformPagecallView {
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required String viewType,
    required void Function(int id) onPlatformViewCreated,
  });
}
