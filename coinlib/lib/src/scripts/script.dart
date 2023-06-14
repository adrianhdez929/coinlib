import 'dart:typed_data';
import 'package:coinlib/src/common/serial.dart';
import 'package:collection/collection.dart';
import 'operations.dart';

class Script {

  // A read only list of the script operations
  final List<ScriptOp> ops;
  Uint8List? _compiledCache;
  String? _asmCache;

  /// Constructs a script from the operations
  Script(List<ScriptOp> ops) : ops = List<ScriptOp>.unmodifiable(ops);

  /// Decompiles the script and may return a sub-class representing the script
  /// type. May return [OutOfData] if the script has an invalid pushdata.
  /// If [requireMinimal] is true, the script push push data minimally or
  /// [PushDataNotMinimal] will be thrown.
  factory Script.decompile(Uint8List script, { bool requireMinimal = false }) {

    final List<ScriptOp> ops = [];
    final reader = BytesReader(script);

    // Read all the operations into the list
    while (!reader.atEnd) {
      ops.add(ScriptOp.fromReader(reader, requireMinimal: requireMinimal));
    }

    return Script(ops);

  }

  /// Constructs a script from the given script assembly string ([asm]). May
  /// return a matching sub-class for the given script.
  factory Script.fromAsm(String asm) => Script(
    asm.split(" ").map((s) => ScriptOp.fromAsm(s)).toList(),
  );

  /// Returns the copied compiled bytes for the script.
  Uint8List get compiled => Uint8List.fromList(
    _compiledCache ??= Uint8List.fromList(
      ops.fold(<int>[], (prev, op) => prev + op.compiled),
    ),
  );

  /// Returns the ASM string representation of the script. All data and integers
  /// are provided in hex format.
  String get asm => _asmCache ??= ops.map((op) => op.asm).join(" ");

  /// Returns true if the script matches another, including a script containing
  /// a [ScriptPushDataMatcher].
  bool match(Script other)
    => ops.length == other.ops.length
    && IterableZip([ops, other.ops]).every((pair) => pair[0].match(pair[1]));

}