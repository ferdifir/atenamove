class BarangModel {
  // [{"idtrans":"8565","kodetrans":"C04SI2507-1782","idbarang":"80","kodebarang":"0601003","namabarang":"ULEG SAMBAL PEDAS 10X18 GR","satuan":"PCS","jml":"50","harga":"1,155","promo":"0","discpersen":"0","tpr":"0.0000","tprpersen":"7.39","totaltpr":"7.39","subtotal":"57,750"},{"idtrans":"8565","kodetrans":"C04SI2507-1782","idbarang":"81","kodebarang":"0601004","namabarang":"ULEG SAMBAL KEMIRI 10X18 GR","satuan":"CTN","jml":"1","harga":"115,541","promo":"0","discpersen":"0","tpr":"0.0000","tprpersen":"7.39","totaltpr":"7.39","subtotal":"115,541"}]
  String? idtrans, kodetrans, idbarang, kodebarang, namabarang, satuan, jml, harga, promo, discpersen, tpr, tprpersen, totaltpr, subtotal;

  BarangModel({
    this.idtrans,
    this.kodetrans,
    this.idbarang,
    this.kodebarang,
    this.namabarang,
    this.satuan,
    this.jml,
    this.harga,
    this.promo,
    this.discpersen,
    this.tpr,
    this.tprpersen,
    this.totaltpr,
    this.subtotal,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) => BarangModel(
        idtrans: json["idtrans"],
        kodetrans: json["kodetrans"],
        idbarang: json["idbarang"],
        kodebarang: json["kodebarang"],
        namabarang: json["namabarang"],
        satuan: json["satuan"],
        jml: json["jml"],
        harga: json["harga"],
        promo: json["promo"],
        discpersen: json["discpersen"],
        tpr: json["tpr"],
        tprpersen: json["tprpersen"],
        totaltpr: json["totaltpr"],
        subtotal: json["subtotal"],
      );
}
