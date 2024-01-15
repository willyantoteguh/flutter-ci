import 'package:rive/rive.dart';

class RiveModel {
  final String path, artboard, stateMachineName;
  late SMIBool? status;

  RiveModel({
    required this.path,
    required this.artboard,
    required this.stateMachineName,
    this.status,
  });

  set setStatus(SMIBool state) {
    status = state;
  }
}
