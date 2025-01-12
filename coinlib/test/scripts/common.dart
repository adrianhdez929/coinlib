import 'package:coinlib/coinlib.dart';
import 'package:test/test.dart';

expectScriptOp(ScriptOp op, String asm, String hex, int? number, bool isPush) {
  expect(op.asm, asm);
  expect(bytesToHex(op.compiled), hex);
  expect(op.number, number);
  expect(op, isPush ? isA<ScriptPushData>() : isA<ScriptOpCode>());
  expect(op.insig, null);
  expect(op.publicKey, null);
}
