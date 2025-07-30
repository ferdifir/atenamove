import 'dart:async';
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
      // final String urlPath = pref.getString("UrlAPI") ?? "";
      const String urlPath = "http://192.168.1.29/ljc/";
      urlAPI = urlPath + urlAPI;
      log("Url API = $urlAPI");
      log("Url BODY = $body");
      if (tipe == TypeReq.POST) {
        log("Tipe Post");
        final formData = FormData.fromMap(body ?? {});
        log("Form Data = ${formData.fields.toString()}");
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
        return ApiResponse.fromJson(response.data);
      } else {
        log("=======================");
        log("||Start Error Message||");
        log("=======================");
        log("Status Code : ${response.statusCode.toString()}");
        log(response.statusMessage);
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

  getDataPerusahaan() {
    String url = "Api/Master/ApiPerusahaan/getDataPerusahaan";
    return sendRequestAPI(urlAPI: url);
  }

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

  GetLinkHelpAplikasi({
    required String idperusahaan,
  }) {
    String url = "Api/ApiData/helpAplikasi";
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
    String url = "Api/Master/ApiSalesman/logout";
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
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglTrans,
    required String pMode,
    required String pJenis,
  }) {
    String url = "Api/Master/ApiCustomer/unduhDataCustomer";
    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tgltrans': pTglTrans,
      'mode': pMode,
      'jenis': pJenis,
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
    String url = "Api/Master/ApiSalesman/updateTglDownload";

    var sendData = {
      'iddepo': pIdDepo,
      'idperusahaan': pIdPerusahaan,
      'tgldownload': pTglDownload,
      'version': pVersion,
      'idsalesman': pIdSalesman,
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

  simpanRuteTidakDikunjungi({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pIdCustomer,
  }) {
    String url = "Api/Master/ApiRute/notifikasiRuteTidakDikunjungi";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'idcustomer': pIdCustomer,
      'approve': "0",
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
    String url = "Api/Master/ApiSalesman/updatePassword";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
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

  simpanAbsen({
    required String pIdPerusahaan,
    required String pIdSalesman,
    required String pJenisRute,
    required String pDataAbsen,
  }) {
    String url = "Api/Master/ApiSalesman/simpanAbsen";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'jenisrute': pJenisRute,
      'dataabsen': pDataAbsen,
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
    required String pIdSalesman,
    required String pIdDepo,
    required String pTglTrans,
    required String pDataJual,
  }) {
    String url = "Api/Penjualan/ApiJual/verifikasiData";

    var sendData = {
      'idperusahaan': pIdPerusahaan,
      'idsalesman': pIdSalesman,
      'iddepo': pIdDepo,
      'tgltrans': pTglTrans,
      'dataJual': pDataJual,
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
