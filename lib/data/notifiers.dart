import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(
  0,
); // Selected Page Notifier for Index stack

ValueNotifier<bool> darkModeNotifier = ValueNotifier(
  false,
); // darkMode Notifer for shared Preff and Material App
