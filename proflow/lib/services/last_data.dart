import 'package:proflow/models/dictionary_m.dart';
import 'package:proflow/screens/dictionary.dart';

//save last data to reduce api calls
DictionaryM? lastDictEntry;
bool get isLastDictEmpty => lastDictEntry == null;
