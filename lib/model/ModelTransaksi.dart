//HALAMAN LOGIN
import 'package:sqflite/sqflite.dart';

import 'DatabaseConnection.dart';

class ModelTransaksi {
  String table = "ttransaksi";

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

  update(data) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      String whereIn = "";
      for (var item in data) {
        whereIn += item['idtrans'] + ",";
      }

      if (whereIn != "") {
        whereIn = whereIn.substring(0, whereIn.length - 1);
      }

      DatabaseConnection.database!.rawDelete("delete from " + table + " where " + table + ".idtrans in (" + whereIn + ")");

      var batch = DatabaseConnection.database!.batch();

      for (var item in data) {
        batch.insert(table, item, conflictAlgorithm: ConflictAlgorithm.rollback);
      }
      await batch.commit(noResult: true);

      print("Success update file");
    } catch (e) {
      print("Couldn't update file");
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

  updateCatatan(text, id) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      print("Success read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada success');
      await DatabaseConnection.database!.rawQuery("update ttransaksi set catatan = '" + text + "' where ttransaksi.idtrans = " + id);

      print("Success update file");
    } catch (e) {
      print("Couldn't update file");
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
      return DatabaseConnection.database!.query(table, where: "idarmada = " + id);
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada failed');
      return [];
    }
  }

  Future<List> selectByID(id) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      print("Success read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada success');
      return DatabaseConnection.database!.rawQuery("select ttransaksi.*,mcustomer.namacustomer from ttransaksi " + "inner join mcustomer on mcustomer.idcustomer = ttransaksi.idcustomer " + "where ttransaksi.idtrans = " + id);
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada failed');
      return [];
    }
  }

  Future<List> selectByIDArmadaCustomer(id) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      print("Success read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada success');
      return DatabaseConnection.database!.rawQuery("select ttransaksi.*,mcustomer.namacustomer from ttransaksi " + "inner join mcustomer on mcustomer.idcustomer = ttransaksi.idcustomer " + "where ttransaksi.idcustomer = " + id + " order by ttransaksi.jenistrans");
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Armada selectByIDArmada failed');
      return [];
    }
  }

  Future<int?> selectJmlData() async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      //DatabaseConnection.readHistory('Customer selectJmlData success');
      return Sqflite.firstIntValue(await DatabaseConnection.database!.rawQuery('SELECT COUNT(*) FROM ' + table));
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Customer selectJmlData failed');
      return null;
    }
  }
}
