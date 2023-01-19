import 'package:flutter/cupertino.dart';
import 'package:proflow/services/dict_define.dart';
import '/services/last_data.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  // Dictionary dictData = lastDictEntry ?? await getDefinition();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    debugPrint('createing dictionary');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hello"),
    );
  }
}
