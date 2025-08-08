import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getAppDirectory() async {
  /// Returns the applications documents directory
  return (await getApplicationDocumentsDirectory());
}

Future<List<Directory>> loadFolders() async {
  /// Returns a list of all user saved folders in the application documents directory

  final Directory appDirectory = await getAppDirectory();
  final String appDirectoryPath = appDirectory.path;

  final Directory userSavedDataDir = Directory(
    "$appDirectoryPath/user_saved_data",
  );

  if (!await userSavedDataDir.exists()) {
    await userSavedDataDir.create(recursive: true);
  }

  final List<FileSystemEntity> userSavedDataContents = await userSavedDataDir
      .list()
      .toList();
  final List<Directory> allFolders = [];

  for (final entity in userSavedDataContents) {
    //Load Directory
    if (entity is Directory) {
      log('Folder: ${entity.path}');
      allFolders.add(entity);
    }
  }
  allFolders.sort((a, b) {
    return a.path.toLowerCase().compareTo(b.path.toLowerCase());
  });
  return allFolders;
}

Future<void> deleteSelectedFolder(Directory folder) async {
  /// Deletes a folder from the application document directory
  try {
    if (await folder.exists()) {
      await folder.delete(recursive: true);
      log("Deleted Item: ${basename(folder.path)}");
    }
  } catch (e) {
    log("Error deleting folder: $e");
  }
}
