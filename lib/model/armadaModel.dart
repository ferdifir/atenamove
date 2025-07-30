class ArmadaModel {
  String idperusahaan = "";
  String iddepo = "";
  String idarmada = "";
  String namaarmada = "";
  String nopolisi = "";
  String statusverifikasi = "";

  ArmadaModel({required this.idperusahaan, required this.iddepo, required this.idarmada, required this.namaarmada, required this.nopolisi, required this.statusverifikasi});

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
}
