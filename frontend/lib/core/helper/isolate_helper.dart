import 'dart:isolate';

void isolateFunc({
  required Function(List<dynamic> args) runTask,
  required Function(dynamic) result,
  dynamic additionalArgs,
}) async {
  print("A");
  final ReceivePort receivePort = ReceivePort();

  print("B");
  try {
    print("C");
    await Isolate.spawn(runTask, [receivePort.sendPort, additionalArgs]);
  } on Object catch (e) {
    print("Error->$e");
    print("D");
    receivePort.close();
  }

  print("E");
  result(await receivePort.first);
}
