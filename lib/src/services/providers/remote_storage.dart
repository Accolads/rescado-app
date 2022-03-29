import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final remoteStorageProvider = Provider<RemoteStorage>(
  (ref) => RemoteStorage._(ref.read),
);

class RemoteStorage {
  static final _logger = addLogger('RemoteStorage');

  final Reader _read;

  RemoteStorage._(this._read);

  Future<String> uploadAvatar([String? path]) async {
    _logger.d('uploadAvatar()');

    final token = await _read(deviceStorageProvider).getToken();

    if (token == null) {
      throw UnsupportedError('Bad programming. Can\'t upload an avatar if we\'re not logged in.');
    }

    final reference = FirebaseStorage.instance.ref('avatars/${token.subject}');

    if (path == null) {
      _logger.w('No avatar provided. Uploading a dummy instead.');

      final bytes = await rootBundle.load('assets/dummies/${Random().nextInt(8)}.jpg');
      final data = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      await reference.putData(data);
      return await reference.getDownloadURL();
    }

    await reference.putFile(File(path));
    return await reference.getDownloadURL();
  }
}
