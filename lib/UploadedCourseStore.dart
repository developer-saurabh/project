import 'package:sembast/sembast.dart';
import 'sembast_database.dart';
import 'uploaded_course.dart';

class UploadedCourseStore {
  static final _store = intMapStoreFactory.store('courses');

  static Future<void> insertCourse(UploadedCourse course) async {
    final db = await SembastDatabase.getInstance();
    await _store.add(db, course.toMap());
  }

  static Future<List<UploadedCourse>> getCourses() async {
    final db = await SembastDatabase.getInstance();
    final snapshots = await _store.find(db);
    return snapshots.map((e) => UploadedCourse.fromMap(e.value)).toList();
  }

  static Future<void> clearAll() async {
    final db = await SembastDatabase.getInstance();
    await _store.delete(db);
  }
}
