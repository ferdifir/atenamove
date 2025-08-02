//HALAMAN LOGIN
import 'package:sqflite/sqflite.dart';

import 'DatabaseConnection.dart';

class ModelArmada {
  String table = "marmada";

  insert(data) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      var batch = DatabaseConnection.database!.batch();

      for (var item in data) {
        batch.insert(table, item, conflictAlgorithm: ConflictAlgorithm.rollback);
      }
      await batch.commit(noResult: true);

      print("Success write file");
    } catch (e) {
      print("Couldn't write file");
    }
  }

  clear() async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      DatabaseConnection.database!.delete(table);

      print("Success delete file");
    } catch (e) {
      print("Couldn't delete file");
    }
  }

  Future<List> select(index) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      //DatabaseConnection.readHistory('Armada select success');
      return DatabaseConnection.database!.query(table);
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Armada select failed');
      return [];
    }
  }

  Future<List> selectByIDArmada(id) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      print("Success read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada success');
      return DatabaseConnection.database!.query(table, where: "idArmada = " + id);
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada failed');
      return [];
    }
  }
}
