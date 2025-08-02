//HALAMAN LOGIN

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseConnection.dart';

class DatabaseModelCustomer {
  String table = "mcustomer";

  Future<void> insert(List<Map<String, dynamic>> data) async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      var batch = db.batch();

      for (var item in data) {
        var existingItem = await db.query(
          table,
          where: 'idcustomer = ?',
          whereArgs: [item['idcustomer']],
        );

        if (existingItem.isNotEmpty) {
          batch.delete(
            table,
            where: 'idcustomer = ?',
            whereArgs: [item['idcustomer']],
          );
        }

        batch.insert(
          table,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();
      print("Success write file");
    } catch (e) {
      print("Couldn't write file: $e");
    }
  }

  Future<void> update(List<Map<String, dynamic>> data) async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      String whereIn = data.map((item) => "'${item['idcustomer']}'").join(',');

      if (whereIn.isNotEmpty) {
        await db.rawDelete(
          "DELETE FROM $table WHERE idcustomer IN ($whereIn)",
        );

        var batch = db.batch();

        for (var item in data) {
          batch.insert(
            table,
            item,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await batch.commit();
        print("Berhasil Update data");
      }
      print("Success update file");
    } catch (e) {
      print("Couldn't update file");
    }
  }

  Future<void> clear() async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();

      await db.delete(table);

      print("Berhasil Clear Tabel");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> select(index) async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      List<Map<String, dynamic>> result = await db.query(table);

      print("Berhasil get All Data");
      return result;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> selectWithPagination(
      int limit, int offset) async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      List<Map<String, dynamic>> result = await db.query(
        table,
        limit: limit,
        offset: offset,
      );

      print("Successfully retrieved data with limit $limit and offset $offset");
      return result;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> selectByIDCustomer(idcustomer) async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      List<Map<String, dynamic>> result = await db.query(
        table,
        where: "idcustomer = ?",
        whereArgs: [idcustomer],
      );

      print("Success: Berhasil get Data by ID $idcustomer");
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<int> selectJmlData() async {
    try {
      final db = await DatabaseConnection.getDatabaseConnect();
      int? count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $table"),
      );

      print("Success: Count retrieved");
      return count ?? 0;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
