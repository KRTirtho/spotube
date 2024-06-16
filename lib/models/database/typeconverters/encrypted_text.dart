part of '../database.dart';

class DecryptedText {
  final String value;
  const DecryptedText(this.value);

  static Encrypter? _encrypter;

  factory DecryptedText.decrypted(String value) {
    _encrypter ??= Encrypter(
      Salsa20(
        Key.fromUtf8(EncryptedKvStoreService.encryptionKeySync),
      ),
    );

    return DecryptedText(
      _encrypter!.decrypt(
        Encrypted.fromBase64(value),
        iv: KVStoreService.ivKey,
      ),
    );
  }

  String encrypt() {
    _encrypter ??= Encrypter(
      Salsa20(
        Key.fromUtf8(EncryptedKvStoreService.encryptionKeySync),
      ),
    );
    return _encrypter!.encrypt(value, iv: KVStoreService.ivKey).base64;
  }
}

class EncryptedTextConverter extends TypeConverter<DecryptedText, String> {
  @override
  DecryptedText fromSql(String fromDb) {
    return DecryptedText.decrypted(fromDb);
  }

  @override
  String toSql(DecryptedText value) {
    return value.encrypt();
  }
}
