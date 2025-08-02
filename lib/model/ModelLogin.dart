//HALAMAN LOGIN
import 'package:sqflite/sqflite.dart';

import 'DatabaseConnection.dart';

class ModelLogin {
  String table = "mlogin";

  insert(data) async {
    try {
      DatabaseConnection.database =
          await DatabaseConnection.getDatabaseConnect();

      var batch = DatabaseConnection.database!.batch();

      for (var item in data) {
        batch.insert(table, item,
            conflictAlgorithm: ConflictAlgorithm.rollback);
      }
      await batch.commit(noResult: true);

      print("Success write file");
    } catch (e) {
      print("Couldn't write file");
    }
  }

  update(data) async {
    try {
      DatabaseConnection.database =
          await DatabaseConnection.getDatabaseConnect();

      var batch = DatabaseConnection.database!.batch();

      for (var item in data) {
        batch.update(table, item,
            where: "iduser = ?", whereArgs: [item['iduser'].toString()]);
      }
      await batch.commit(noResult: true);

      print("Success update file");
    } catch (e) {
      print("Couldn't update file");
    }
  }

  clear() async {
    try {
      DatabaseConnection.database =
          await DatabaseConnection.getDatabaseConnect();

      DatabaseConnection.database!.delete(table);

      print("Success delete file");
    } catch (e) {
      print("Couldn't delete file");
    }
  }

  Future<List> select(index) async {
    try {
      DatabaseConnection.database =
          await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      return DatabaseConnection.database!.query(table);
    } catch (e) {
      print("Couldn't read file");
      return [];
    }
  }
}
