import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

class BlurService {
  static Widget wrap(Widget child) {
    return SecureApplication(child: child);
  }
}
