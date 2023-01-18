import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlarmAndTimer extends StatefulWidget {
  const AlarmAndTimer({super.key});

  @override
  State<AlarmAndTimer> createState() => _AlarmState();
}

class _AlarmState extends State<AlarmAndTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("AlarmAndTimer"),
    );
  }
}
