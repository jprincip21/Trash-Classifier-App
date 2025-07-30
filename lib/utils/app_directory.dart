import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory> getAppDirectory() async {
  return (await getApplicationDocumentsDirectory());
}
