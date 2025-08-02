class TransaksiModel {
  String? idperusahaan, idcustomer, idsortir, idtrans, kodetrans, tgltrans, jenistrans, total, discrp, tprrp, grandtotalraw, grandtotal, catatan, detail;

  TransaksiModel({
    this.idperusahaan,
    this.idcustomer,
    this.idsortir,
    this.idtrans,
    this.kodetrans,
    this.tgltrans,
    this.jenistrans,
    this.total,
    this.discrp,
    this.tprrp,
    this.grandtotalraw,
    this.grandtotal,
    this.catatan,
    this.detail,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      idperusahaan: json['idperusahaan'].toString(),
      idcustomer: json['idcustomer'].toString(),
      idsortir: json['idsortir'].toString(),
      idtrans: json['idtrans'].toString(),
      kodetrans: json['kodetrans'].toString(),
      tgltrans: json['tgltrans'].toString(),
      jenistrans: json['jenistrans'].toString(),
      total: json['total'].toString(),
      discrp: json['discrp'].toString(),
      tprrp: json['tprrp'].toString(),
      grandtotalraw: json['grandtotalraw'].toString(),
      grandtotal: json['grandtotal'].toString(),
      catatan: json['catatan'].toString(),
      detail: json['detail'].toString(),
    );
  }
}
