import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(
  0,
); // Selected Page Notifier for Index stack

ValueNotifier<bool> darkModeNotifier = ValueNotifier(
  false,
); // darkMode Notifer for shared Preff and Material App

ValueNotifier<XFile?> imageCapturedNotifier = ValueNotifier<XFile?>(
  null,
); //Tells us if there is an image captured or not

ValueNotifier<bool> newSavedDataNotifier = ValueNotifier(
  false,
); //Tells us when a new image is saved.
