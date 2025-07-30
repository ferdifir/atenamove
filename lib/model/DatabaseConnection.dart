//HALAMAN LOGIN
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  static Database? database;

  // Initialize database
  static Future<Database> initDatabase() async {
    database = await openDatabase(
      // Ensure the path is correctly for any platform
      join(await getDatabasesPath(), "lajujayasopir.db"),
      onCreate: (db, version) async {
        await db.execute("create table mlogin("
            "tglunduh text,"
            "tglaktif text,"
            "idperusahaan text,"
            "namaperusahaan text,"
            "iddepo text,"
            "namadepo text,"
            "database text,"
            "iduser text,"
            "idarmada text,"
            "kodeuser text,"
            "username text,"
            "jabatan text,"
            "toleransijarak text,"
            "pass text,"
            "login text,"
            "versi text,"
            "tokenfirebase text"
            ");");

        await db.execute("create table marmada("
            "idperusahaan text,"
            "iddepo text,"
            "idarmada text,"
            "namaarmada text,"
            "nopolisi text,"
            "statusverifikasi text"
            ");");

        await db.execute("create table mcustomer("
            "idperusahaan text,"
            "idcustomer text,"
            "kodecustomer text,"
            "namacustomer text,"
            "grandtotal text,"
            "telp text,"
            "alamat text,"
            "latitude text,"
            "longitude text,"
            "latitudeabsen text,"
            "longitudeabsen text,"
            "tglcheckin text,"
            "tglcheckout text,"
            "catatanabsen text,"
            "statuskunjungan text,"
            "fotoabsen text,"
            "namafotoabsen text"
            ");");

        await db.execute("create table ttransaksi("
            "idperusahaan text,"
            "idcustomer text,"
            "idsortir text,"
            "idtrans text,"
            "kodetrans text,"
            "tgltrans text,"
            "jenistrans text,"
            "total text,"
            "discrp text,"
            "tprrp text,"
            "grandtotalraw text,"
            "grandtotal text,"
            "catatan text,"
            "detail text"
            ");");

        print("Make New Database");
      },

      // Version
      version: 1,
    );

    return database!;
  }

  // Check database connected
  static Future<Database> getDatabaseConnect() async {
    if (database != null) {
      print("Database Connect");
      return database!;
    } else {
      print("Database Disconnect");
      return await initDatabase();
    }
  }

  static Future<Database?> resetDatabase() async {
    try {
      deleteDatabase(database!.path);
      print("Reset database success");
      return await initDatabase();
    } catch (e) {
      print("Couldn't delete database$e");
      return null;
    }
  }

  static void showTable() async {
    print(database!.rawQuery('SELECT * FROM sqlite_master ORDER BY name;'));
  }

  static void showColumn(table) async {
    print(database!.rawQuery('PRAGMA table_info(' + table + ')'));
  }
}
