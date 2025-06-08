import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastDatabase {
  static final SembastDatabase _instance = SembastDatabase._();
  static Database? _db;

  SembastDatabase._();

  static Future<Database> getInstance() async {
    if (_db != null) return _db!;

    if (kIsWeb) {
      final factory = databaseFactoryWeb;
      _db = await factory.openDatabase('courses.db');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, 'courses.db');
      final factory = databaseFactoryIo;
      _db = await factory.openDatabase(dbPath);
    }

    return _db!;
  }
}
