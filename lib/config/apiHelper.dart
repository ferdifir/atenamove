import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:atenamove/api/api_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TypeReq { POST, GET, DOWNLOAD }

class ApiHelper {
  final BuildContext? context;
  final bool isShowDialogLoading;
  final bool isShowDialogError;
  final bool isDebugGetResponse;

  bool isError = false;
  bool isErrorConnection = false;
  bool isErrorResponse = false;
  var errorMessage = "";
  static final dio = Dio();

  ApiHelper({this.context, this.isShowDialogLoading = true, this.isShowDialogError = true, this.isDebugGetResponse = false});

  Future _checkConnection() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        isError = true;
      }
    } catch (err) {
      isError = true;
    }
    if (isError) {
      _setError(isErrorConnection, true, "Error");
    }
  }

  void _setError(bool isErrorConnection, bool isErrorResponse, var errorMessage) {
    isError = true;
    this.isErrorConnection = isErrorConnection;
    this.isErrorResponse = isErrorResponse;
    this.errorMessage = errorMessage;
  }

  init() {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<ApiResponse?> sendRequestAPI({required String urlAPI, dynamic body, TypeReq tipe = TypeReq.POST}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await _checkConnection();
    dynamic response;
    try {
      final String urlPath = pref.getString("UrlAPI") ?? "http://192.168.1.29/ljc/";
      // const String urlPath = "http://192.168.1.29/ljc/";
      urlAPI = urlPath + urlAPI;
      log("Url API = $urlAPI");
      log("Url BODY = $body");
      if (tipe == TypeReq.POST) {
        log("Tipe Post");
        final formData = FormData.fromMap(body ?? {});
        response = await dio.post(urlAPI, data: formData);
      } else if (tipe == TypeReq.GET) {
        response = await dio.get(urlAPI, queryParameters: body ?? {});
      }
      if (response == null) {
        log("response berisi null");
        return null;
      }
      if (response.statusCode == 200) {
        log("response status code 200");
        // final result = extractJsonFromMixedResponse(response.data);
        // log(result.toString());
        // if (result != null) {
        //   return ApiResponse.fromJson(result);
        // }
        return ApiResponse.fromJson(response.data);
      } else {
        log("=======================");
        log("||Start Error Message||");
        log("=======================");
        log("Status Code : ${response.statusCode.toString()}");
        log(response.statusMessage);
        log(response.data);
        log("=======================");
        log("||End Error Message  ||");
        log("=======================");
        return null;
      }
    } catch (e) {
      print("=======================");
      print("||Start Error Message||");
      print("=======================");
      print(e);
      print("=======================");
      print("||End Error Message  ||");
      print("=======================");
      return null;
    }
  }

  Map<String, dynamic>? extractJsonFromMixedResponse(String responseText) {
    try {
      final decoded = json.decode(responseText);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException catch (e) {
      print('DEBUG: Percobaan langsung gagal (bukan JSON murni): $e');
    } catch (e) {
      print('ERROR: Kesalahan tak terduga saat penguraian awal: $e');
      return null;
    }

    int firstBraceIndex = responseText.indexOf('{');
    int lastBraceIndex = responseText.lastIndexOf('}');

    if (firstBraceIndex != -1 && lastBraceIndex != -1 && firstBraceIndex < lastBraceIndex) {
      String potentialJsonString = responseText.substring(firstBraceIndex, lastBraceIndex + 1);

      try {
        final decoded = json.decode(potentialJsonString);
        if (decoded is Map<String, dynamic>) {
          print('DEBUG: Berhasil mengekstrak dan mengurai JSON dari tengah.');
          return decoded;
        }
      } on FormatException catch (e) {
        print('DEBUG: Gagal mengurai potongan JSON pertama: $e');
      } catch (e) {
        print('ERROR: Kesalahan saat mengurai potongan JSON: $e');
      }
    } else {
      print('DEBUG: Karakter `{` atau `}` tidak ditemukan atau dalam urutan yang salah.');
    }

    print('Peringatan: Tidak dapat mengekstrak JSON objek yang valid dari respons.');
    return null;
  }

  cekVerifikasi({
    required String pIdPerusahaan,
    required String idUser,
    required String tanggal,
    required String jabatan,
  }) {
    String url = "Api/Master/ApiPegawai/cekVerifikasiData";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': idUser,
      'tanggal': tanggal,
      'jabatan': jabatan,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanRuteTidakDikunjungi({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdUser,
    required String pJabatan,
    required String pIdCustomer,
    required String pTanggal,
    required String pApprove,
  }) {
    String url = "Api/Master/ApiPegawai/notifikasiRuteTidakDikunjungi/";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'iduser': pIdUser,
      'jabatan': pJabatan,
      'idcustomer': pIdCustomer,
      'tanggal': pTanggal,
      'approve': pApprove,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanAbsen({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdUser,
    required String pJabatan,
    required String pTglTrans,
    required String pDataAbsen,
  }) {
    String url = "Api/Master/ApiPegawai/simpanAbsen";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'iduser': pIdUser,
      'jabatan': pJabatan,
      'tgltrans': pTglTrans,
      'dataabsen': pDataAbsen,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanAll({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdUser,
    required String pJabatan,
    required String pDatatransaksi,
  }) {
    String url = "Api/SortirPengiriman/ApiSortir/simpanAll";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'iduser': pIdUser,
      'jabatan': pJabatan,
      'datatransaksi': pDatatransaksi,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  approveRuteTakDikunjungi({
    required String pIdPerusahaan,
    required String pUrutan,
    required String pIdCustomer,
    required String pUserApprove,
    required String pTanggal,
    required String pAlasan,
  }) {
    String url = "Api/Master/ApiPegawai/notifikasiRuteTidakDikunjungi/";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'urutan': pUrutan,
      'idcustomer': pIdCustomer,
      'userapprove': pUserApprove,
      'tanggal': pTanggal,
      'alasan': pAlasan,
      'approve': "1",
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDataArmada({
    required String pIdPerusahaan,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiArmada/getAll";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getRuteTakDikunjungi({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pTanggal,
  }) {
    String url = "Api/Master/ApiPegawai/comboGridApiRuteTidakDikunjungi";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'tanggal': pTanggal,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  batalVerifikasiArmada({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdArmada,
    required String pTanggal,
  }) {
    String url = "Api/Master/ApiPegawai/batalkanVerifikasiData";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'idarmada': pIdArmada,
      'tanggal': pTanggal,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDataHelper({
    required String pIdPerusahaan,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiPegawai/getDataHelper";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDataSopir({
    required String pIdPerusahaan,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiPegawai/getDataSopir";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDataPerusahaan() {
    String url = "Api/Master/ApiPerusahaan/getDataPerusahaan";
    return sendRequestAPI(urlAPI: url);
  }

  cekLogin({
    required String pIdPerusahaan,
    required String pUsername,
    required String pPassword,
  }) {}

  getLogin({
    required bool pIsRelogin,
    required String pIdPerusahaan,
    String? pUsername,
    String? pPassword,
    String? pIdUser,
  }) {
    String url = "Api/Master/ApiPegawai/cekLogin";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'username': pUsername ?? "",
      'password': pPassword ?? "",
    };
    if (pIsRelogin) {
      sendData = {
        'idperusahaan': pIdPerusahaan,
        'username': pUsername ?? "",
        'password': pPassword ?? "",
      };
    }
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getArmada({
    required String idperusahaan,
    required String iddepo,
    required String tglkirim,
  }) {
    String url = "Api/Master/ApiArmada/getDataArmada";
    var sendJson = {
      'idperusahaan': idperusahaan,
      'iddepo': iddepo,
      'tglkirim': tglkirim,
    };
    return sendRequestAPI(urlAPI: url, body: sendJson);
  }

  updateArmada({
    required String idperusahaan,
    required String iddepo,
    required String iduser,
    required String idarmada,
  }) {
    String url = "Api/Master/ApiPegawai/updateArmadaLogin";
    var sendJson = {
      'idperusahaan': idperusahaan,
      'iddepo': iddepo,
      'iduser': iduser,
      'idarmada': idarmada,
    };
    return sendRequestAPI(urlAPI: url, body: sendJson);
  }

  CheckVerifikasi({
    required String idperusahaan,
    required String idsalesman,
    required String tanggal,
  }) {
    String url = "Api/Master/ApiSalesman/cekVerifikasiData";
    var sendJson = {
      'idperusahaan': idperusahaan,
      'idsalesman': idsalesman,
      'tanggal': tanggal,
    };
    return sendRequestAPI(urlAPI: url, body: sendJson);
  }

  getLinkHelpAplikasi({
    required String idperusahaan,
  }) {
    String url = "Api/ApiData/helpAplikasi";
    var sendJson = {
      'idperusahaan': idperusahaan,
    };
    return sendRequestAPI(urlAPI: url, body: sendJson);
  }

  updateAplikasi({
    required String idperusahaan,
  }) {
    String url = "Api/ApiData/updateAplikasi";
    var sendJson = {
      'idperusahaan': idperusahaan,
    };
    return sendRequestAPI(urlAPI: url, body: sendJson);
  }

  checkVersi({
    required String pVersion,
    required String pIdPerusahaan,
  }) {
    String url = "Api/apiData/cekVersi";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'versi': pVersion,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  logout({
    required String pIdPerusahaan,
    required String pIdUser,
  }) {
    String url = "Api/Master/ApiPegawai/logout";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      "iduser": pIdUser,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getSalesman({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiSalesman/getSalesmanID";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdUser,
      'iddepo': pIdDepo,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomer({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pIdDepo,
    required String pTglKirim,
    required String pJabatan,
    required String pIdArmada,
  }) {
    String url = "Api/Master/ApiCustomer/getDataCustomerSortir";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdUser,
      'iddepo': pIdDepo,
      'tglkirim': pTglKirim,
      'jabatan': pJabatan,
      'idarmada': pIdArmada,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getTransaksi({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pIdDepo,
    required String pTglKirim,
    required String pJabatan,
    required String pIdArmada,
  }) {
    String url = "Api/SortirPengiriman/ApiSortir/getDataTransaksiApi";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdUser,
      'iddepo': pIdDepo,
      'tglkirim': pTglKirim,
      'jabatan': pJabatan,
      'idarmada': pIdArmada,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  resetArmadaLogin({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiPegawai/resetArmadaLogin";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdUser,
      'iddepo': pIdDepo,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerInstitusi({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required String pJenis,
  }) {
    String url = "Api/Master/ApiCustomer/unduhDataInstitusi";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'jenis': pJenis,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getSupplier({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pLimit,
    required String pOffset,
    required String pMode,
    required String pTglFilter,
  }) {
    String url = "Api/Master/ApiSupplier/unduhDataSupplier";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdUser,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDivisi({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pLimit,
    required String pOffset,
    required String pMode,
    required String pTglFilter,
  }) {
    String url = "Api/Master/ApiSalesman/getDataDivisi";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdUser,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerBarang({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglUnduh,
    required String pJenis,
  }) {
    String url = "Api/Master/ApiCustomer/unduhDataCustomerBarang";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tglunduh': pTglUnduh,
      'jenis': pJenis,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getBarang({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pLimit,
    required String pOffset,
    required String pMode,
    required String pTglFilter,
    required String pIdSalesman,
  }) {
    String url = "Api/Master/ApiBarang/unduhDataBarang";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
      'idsalesman': pIdSalesman,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerLuarRute({
    required String pIdPerusahaan,
    required String pJabatan,
    required String pIdSalesman,
    required String pIdSupervisor,
    required String pCheckAbsen,
    required String pNamaCustomer,
    required String pTanggal,
    required String pApprove,
  }) {
    String url = "Api/Master/ApiRute/unduhDataLuarRute";
    Map<String, dynamic> sendData = {};
    if (pJabatan == "SALESMAN") {
      sendData = {
        'idperusahaan': pIdPerusahaan,
        'idsalesman': pIdSalesman,
        'checkAbsen': pCheckAbsen,
        // 'namacustomer': "",
        'tanggal': pTanggal,
        'approve': pApprove
      };
    } else {
      sendData = {
        'idperusahaan': pIdPerusahaan,
        'idsupervisor': pIdSupervisor,
        'checkAbsen': pCheckAbsen,
        // 'namacustomer': "",
        'tanggal': pTanggal,
        'approve': pApprove
      };
    }

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerSupplier({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pOffset,
    required String pLimit,
    required String pMode,
    required String pTglFilter,
  }) {
    String url = "Api/Master/ApiCustomer/unduhDataCustomerSupplier";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerSupplierInstitusi({
    required String pIdPerusahaan,
    required String pOffset,
    required String pLimit,
    required String pMode,
    required String pTglFilter,
  }) {
    String url = "Api/Master/ApiCustomer/unduhDataCustomerSupplier";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getPenjualanTerakhir({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pOffset,
    required String pLimit,
    required String pMode,
    required String pTglFilter,
  }) {
    String url = "Api/Penjualan/ApiJual/unduhDataPenjualanTerakhir";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'limit': pLimit,
      'offset': pOffset,
      'mode': pMode,
      'tglfilter': pTglFilter,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  updateTglUnduh({
    required String pIdDepo,
    required String pIdPerusahaan,
    required String pTglDownload,
    required String pVersion,
    required String pIdSalesman,
  }) {
    String url = "Api/Master/ApiPegawai/updateTglDownload";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'tgldownload': pTglDownload,
      'version': pVersion,
      'iduser': pIdSalesman,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  sendEmailFakeGPS({
    required String pIdPerusahaan,
    required String pNamaSalesman,
  }) {
    String url = "Api/Master/ApiSalesman/sendFakeGPSEmail";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'namasalesman': pNamaSalesman,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  ApproveRuteTidakDikunjungi({required String pIdPerusahaan, required String pIdSalesman, required String pIdUser, required String pIdCustomer, required String pAlasan, required String pUrutan}) {
    String url = "Api/Master/ApiRute/notifikasiRuteTidakDikunjungi";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'idcustomer': pIdCustomer,
      'approve': "1",
      'alasan': pAlasan,
      'urutan': pUrutan,
      'userapprove': pIdUser,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  gantiPassword({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pPasswordLama,
    required String pPasswordBaru,
  }) {
    String url = "Api/Master/ApiPegawai/updatePassword";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iduser': pIdSalesman,
      'passwordlama': pPasswordLama,
      'passwordbaru': pPasswordBaru,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanDataJual({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pDataJual,
  }) {
    String url = "Api/Penjualan/ApiJual/simpanAll";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'dataJual': pDataJual,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanDataSetoran({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdsalesman,
    required String pDataSetoran,
  }) {
    String url = "Api/Keuangan/ApiPelunasan/sinkronisasiSetoranSalesman";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'idsalesman': pIdsalesman,
      'data': pDataSetoran,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanValidAO({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pData,
  }) {
    String url = "Api/Penjualan/ApiJual/simpanValidAO";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'data': pData,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getRute({
    required String pIdPerusahaan,
    required String pIdDepo,
    required String pIdSalesman,
  }) {
    String url = "Api/Master/ApiRute/UnduhDataRute";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'idsalesman': pIdSalesman,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanNOO({required String pIdPerusahaan, required String pIdDepo, required String pDataCustomer, required String pIdSalesman}) {
    String url = "Api/Master/ApiCustomer/simpanAll";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'datacustomer': pDataCustomer,
      "idsalesman": pIdSalesman,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getArea({
    required String pIdPerusahaan,
    required String pIdDepo,
  }) {
    String url = "Api/Master/ApiArea/unduhDataArea";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  verifikasiSalesman({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglTrans,
  }) {
    String url = "Api/Penjualan/ApiJual/verifikasiDataKepala";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tgltrans': pTglTrans,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  batalVerifikasiSalesman({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglTrans,
  }) {
    String url = "Api/Master/ApiSalesman/batalkanVerifikasiData";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tanggal': pTglTrans,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getRuteTidakDikunjungi({
    required String pIdPerusahaan,
    required String pIdSupervisor,
  }) {
    String url = "Api/Master/ApiRute/unduhDataRuteTidakDikunjungi";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsupervisor': pIdSupervisor,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getLaporanHarian({required String pIdPerusahaan, required String pIdSalesman, required String pIdDepo, required String pTglTrans, required String pIdRute}) {
    String url = "Api/Laporan/ApiSalesman/getLaporanHarian";

    var sendData = {'idperusahaan': pIdPerusahaan, 'idsalesman': pIdSalesman, 'iddepo': pIdDepo, 'tgltrans': pTglTrans, 'idrute': pIdRute};

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDepartemen({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
  }) {
    String url = "Api/Laporan/ApiSalesman/getDataDepartemen";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getPromo({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pTglTrans,
    required String query,
  }) {
    String url = "Api/Master/ApiPromo/getDaftarPromoDivisi";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'tgltrans': pTglTrans,
      'q': query,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getPiutang({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pTglTrans,
  }) {
    String url = "Api/Master/ApiCustomer/getDataPiutang";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'tgltrans': pTglTrans,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  simpanLuarRuteSales({
    required String pIdPerusahaan,
    required String pDataRuteTambahan,
  }) {
    String url = "Api/Master/ApiRute/simpanRuteTambahanAll";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'datarutetambahan': pDataRuteTambahan,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  batalApprove({
    required String pIdPerusahaan,
    required String pIdCustomer,
    required String pUrutan,
  }) {
    String url = "Api/Master/ApiRute/batalApprove";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idcustomer': pIdCustomer,
      'urutan': pUrutan,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  verifikasiKhusus({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglTrans,
    required String pDataJual,
  }) {
    String url = "Api/Penjualan/ApiJual/verifikasiKhusus";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tgltrans': pTglTrans,
      'dataJual': pDataJual,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  verifikasiData({
    required String pIdPerusahaan,
    required String pIdUser,
    required String pIdDepo,
    required String pTglTrans,
    required String iduser2,
    required String pIdArmada,
    required String pCatatan,
    required String pJabatan,
    required List dataTransaksi,
  }) {
    String url = "Api/SortirPengiriman/ApiSortir/verifikasiData";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'iduser': pIdUser,
      'iduser2': iduser2,
      'jabatan': pJabatan,
      'tgltrans': pTglTrans,
      'idarmada': pIdArmada,
      'datatransaksi': json.encode(dataTransaksi).isEmpty ? json.encode([]) : json.encode(dataTransaksi),
      'catatan': pCatatan,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getCustomerLaporan({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdDepo,
    required bool pIsInstitusi,
    String? pTanggal,
  }) {
    String url = 'Api/Master/ApiCustomer/comboGridApi';
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
    };
    if (pIsInstitusi) {
      url = 'Api/Master/ApiCustomer/comboGridApiInstitusi';
      sendData['jenis'] = "ABSEN";
    } else {
      sendData['mode'] = "TAMBAH";
      sendData['jenis'] = 'DALAM';
      sendData['tgltrans'] = pTanggal ?? "";
    }
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getRuteLaporan({
    required String pIdPerusahaan,
    required String ruteID,
    required String pIdDepo,
  }) {
    String url = 'Api/Master/ApiRute/UnduhDataRute';
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'iddepo': pIdDepo,
      'idrute': ruteID,
    };
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getDataTagihan({
    required String pIdPerusahaan,
    required String pTanggal,
    required String pIdDepo,
    required String pIdSalesman,
  }) {
    String url = 'Api/Keuangan/ApiPelunasan/getDataTagihan';
    var sendData = {'idperusahaan': pIdPerusahaan, 'iddepo': pIdDepo, 'tanggal': pTanggal, 'idsalesman': pIdSalesman};
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getHitungPromo({
    required String pIdPerusahaan,
    required String pIddivisi,
    required String pIdcustomer,
    required String pDataDetail,
  }) {
    String url = 'Api/Master/ApiPromo/hitungPromo';
    var sendData = {'idperusahaan': pIdPerusahaan, 'iddivisi': pIddivisi, 'idcustomer': pIdcustomer, 'tanggal': DateFormat("yyyy-MM-dd").format(DateTime.now()), 'data_detail': pDataDetail};
    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getTagihan({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pTglTrans,
    required String pIdDepo,
  }) {
    String url = "Api/Keuangan/ApiPelunasan/getDataTagihan";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'tanggal': pTglTrans,
      'iddepo': pIdDepo,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  sendOutletCoordinate({
    required String pIdPerusahaan,
    required String pIdCustomer,
    required String plat,
    required String plong,
  }) {
    String url = "Api/Master/ApiCustomer/updateKoordinat";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idcustomer': pIdCustomer,
      'lat': plat,
      'long': plong,
    };

    return sendRequestAPI(urlAPI: url, body: sendData);
  }

  getLaporanPenjualanDetail(Map<String, dynamic> data) {
    String url = "Api/Laporan/ApiSalesman/getLaporanDetailJual";

    return sendRequestAPI(urlAPI: url, body: data);
  }
}
