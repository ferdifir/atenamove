class ArmadaModel {
  String? idperusahaan = "";
  String? iddepo = "";
  String? idarmada = "";
  String? namaarmada = "";
  String? nopolisi = "";
  String? statusverifikasi = "";

  ArmadaModel({this.idperusahaan, this.iddepo, this.idarmada, this.namaarmada, this.nopolisi, this.statusverifikasi});

  factory ArmadaModel.fromJson(Map<String, dynamic> json) {
    return ArmadaModel(
      idperusahaan: json['idperusahaan'],
      iddepo: json['iddepo'],
      idarmada: json['idarmada'],
      namaarmada: json['namaarmada'],
      nopolisi: json['nopolisi'],
      statusverifikasi: json['statusverifikasi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idperusahaan'] = idperusahaan;
    data['iddepo'] = iddepo;
    data['idarmada'] = idarmada;
    data['namaarmada'] = namaarmada;
    data['nopolisi'] = nopolisi;
    data['statusverifikasi'] = statusverifikasi;
    return data;
  }
}
