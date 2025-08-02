//HALAMAN LOGIN

import 'package:sqflite/sqflite.dart';

import 'DatabaseConnection.dart';

class ModelCustomer {
  String table = "mcustomer";

  insert(data) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      var batch = DatabaseConnection.database!.batch();

      for (var item in data) {
        batch.insert(table, item, conflictAlgorithm: ConflictAlgorithm.rollback);
      }
      await batch.commit(noResult: true);

      print("Success write file");
      //DatabaseConnection.readHistory('Customer insert success');
    } catch (e) {
      print("Couldn't write file");
      //DatabaseConnection.readHistory('Customer insert failed');
    }
  }

  update(data) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      String whereIn = "";
      for (var item in data) {
        whereIn += item['idcustomer'] + ",";
      }

      if (whereIn != "") {
        whereIn = whereIn.substring(0, whereIn.length - 1);
      }

      DatabaseConnection.database!.rawDelete("delete from " + table + " where " + table + ".idcustomer in (" + whereIn + ")");

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

  Future<List> checkAbsen(tanggal, statuscheck, catatanabsen, statuskunjungan, lat, long, foto, namafoto, idcustomer) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      var settglcheck = "";
      if (statuscheck == "CHECK IN") {
        settglcheck = "tglcheckin = '" + tanggal + "' , latitudeabsen = '" + lat + "' , longitudeabsen = '" + long + "' , fotoabsen = '" + foto + "' , namafotoabsen = '" + namafoto + "'";
      } else if (statuscheck == "CHECK OUT") {
        settglcheck = "tglcheckout = '" + tanggal + "', statuskunjungan = '" + statuskunjungan + "', catatanabsen = '" + catatanabsen + "'";
      }

      await DatabaseConnection.database!.rawUpdate("update " + table + " set " + settglcheck + " where idcustomer = " + idcustomer);

      print("Success " + statuscheck);

      return DatabaseConnection.database!.query(table, where: "idcustomer = ? ", whereArgs: [idcustomer.toString()]);
    } catch (e) {
      print(e);
      print("Couldn't " + statuscheck);
      return [];
    }
  }

  Future<List> updateAbsen(statuscheck, catatanabsen, idcustomer) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      await DatabaseConnection.database!.rawUpdate("update " + table + " set " + "catatanabsen = '" + catatanabsen + "'" + " where idcustomer = " + idcustomer);

      print("Success " + statuscheck);

      return DatabaseConnection.database!.query(table, where: "idcustomer = ? ", whereArgs: [idcustomer.toString()]);
    } catch (e) {
      print("Couldn't " + statuscheck);
      return [];
    }
  }

  Future<List> select(index) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      //DatabaseConnection.readHistory('Customer select success');
      return DatabaseConnection.database!.query(table);
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Customer select failed');
      clear();
      return [];
    }
  }

  Future<List> selectWithGrandtotal(index) async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      //DatabaseConnection.readHistory('Customer select success');
      return DatabaseConnection.database!.rawQuery(
          "select mcustomer.*, sum(case when ttransaksi.jenistrans = 'PENJUALAN' then ttransaksi.grandtotalraw else -ttransaksi.grandtotalraw end) as grandtotal,  sum(case when ttransaksi.jenistrans = 'PENJUALAN' then ttransaksi.grandtotalraw else 0 end) as  grandtotalpenjualan, sum(case when ttransaksi.jenistrans = 'PERMINTAAN RETUR' then ttransaksi.grandtotalraw else 0 end) as  grandtotalpermintaanretur " +
              " from mcustomer" +
              " inner join ttransaksi on ttransaksi.idcustomer = mcustomer.idcustomer" +
              " group by mcustomer.kodecustomer" +
              " order by mcustomer.namacustomer");
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Customer select failed');
      clear();
      return [];
    }
  }

  Future<List> selectAbsen() async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();

      print("Success read file");
      //DatabaseConnection.readHistory('Customer Dalam Rute selectAbsen success');
      return DatabaseConnection.database!.rawQuery("select * from " + table + " where tglcheckout != 'null'");
    } catch (e) {
      print("Couldn't read file");

      //DatabaseConnection.readHistory('Customer Dalam Rute selectAbsen failed');
      return [];
    }
  }

  Future<int?> selectJmlData() async {
    try {
      DatabaseConnection.database = await DatabaseConnection.getDatabaseConnect();
      print("Success read file");
      //DatabaseConnection.readHistory('Customer selectJmlData success');
      return await Sqflite.firstIntValue(await DatabaseConnection.database!.rawQuery('SELECT COUNT(*) FROM ' + table));
    } catch (e) {
      print("Couldn't read file");
      //DatabaseConnection.readHistory('Customer selectJmlData failed');
      return null;
    }
  }
}
