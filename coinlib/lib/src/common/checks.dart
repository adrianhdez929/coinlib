
_checkInt(int i, int min, int max, String type, String name) {
  if (i < min || i > max) {
    throw ArgumentError.value(i, name, "must be a $type");
  }
}

checkUint8(int i, [String name = "i"])
  => _checkInt(i, 0, 0xff, "uint8", name);

checkUint16(int i, [String name = "i"])
  => _checkInt(i, 0, 0xffff, "uint16", name);

checkUint32(int i, [String name = "i"])
  => _checkInt(i, 0, 0xffffffff, "uint32", name);

checkInt32(int i, [String name = "i"])
  => _checkInt(i, -0x80000000, 0x7fffffff, "int32", name);

final BigInt maxUint64 = (BigInt.from(1) << 64) - BigInt.one;

checkUint64(BigInt i, [String name = "i"]) {
  if (i.isNegative || i > maxUint64) {
    throw ArgumentError.value(i, name, "must be a uint64");
  }
}
