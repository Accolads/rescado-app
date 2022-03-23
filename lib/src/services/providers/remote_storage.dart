import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';
import 'package:flutter/services.dart' show rootBundle;

final remoteStorageProvider = Provider<RemoteStorage>(
  (ref) => RemoteStorage._(ref.read),
);

class RemoteStorage {
  static final _logger = addLogger('RemoteStorage');

  final Reader _read;

  RemoteStorage._(this._read);

  Future<void> uploadAvatar([String? path]) async {
    _logger.d('uploadAvatar()');

    final token = await _read(deviceStorageProvider).getToken();

    if (token == null) {
      throw UnsupportedError('Bad programming. Can\'t upload an avatar if we\'re not logged in.');
    }

    if (path == null) {
      _logger.w('No avatar provided. Uploading a dummy instead.');

      final bytes = await rootBundle.load('assets/dummies/2.jpg');
      final data = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      FirebaseStorage.instance.ref('avatars/${token.subject}').putData(data).then((_) => print('okidoki'));
      return;
    }

    FirebaseStorage.instance.ref('avatars/${token.subject}').putFile(File(path));
  }
}
