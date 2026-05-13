import 'package:nfc_manager/nfc_manager.dart';

String? getNfcTagId(NfcTag tag) {
  final candidates = <String>[];
  _collectIdentifiers(tag.data, candidates);
  if (candidates.isEmpty) return null;
  candidates.sort((a, b) => b.length.compareTo(a.length));
  return candidates.first;
}

void _collectIdentifiers(dynamic value, List<String> candidates) {
  if (value is Map) {
    for (final entry in value.entries) {
      final key = entry.key.toString().toLowerCase();
      final entryValue = entry.value;
      if ((key == 'identifier' || key == 'id') && entryValue is List) {
        final bytes = entryValue.whereType<num>().map((e) => e.toInt()).toList();
        if (bytes.isNotEmpty) {
          candidates.add(
            bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
          );
        }
      }
      _collectIdentifiers(entryValue, candidates);
    }
  } else if (value is List) {
    for (final child in value) {
      _collectIdentifiers(child, candidates);
    }
  }
}
