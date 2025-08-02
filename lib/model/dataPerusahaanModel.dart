
class DataPerusahaanModel {
  String? idperusahaan;
  String? kodeperusahaan;
  String? namaperusahaan;
  String? prosesopname;
  String? email;
  String? alamat;
  String? kota;
  String? propinsi;
  String? negara;
  String? kodepos;
  String? telp;
  String? fax;
  String? npwp;
  String? catatan;
  String? informasirekening;
  String? userentry;
  String? tglentry;
  String? status;

  DataPerusahaanModel({
    this.idperusahaan,
    this.kodeperusahaan,
    this.namaperusahaan,
    this.prosesopname,
    this.email,
    this.alamat,
    this.kota,
    this.propinsi,
    this.negara,
    this.kodepos,
    this.telp,
    this.fax,
    this.npwp,
    this.catatan,
    this.informasirekening,
    this.userentry,
    this.tglentry,
    this.status,
  });

  DataPerusahaanModel.fromJson(Map<String, dynamic> json) {
    idperusahaan = json['idperusahaan'];
    kodeperusahaan = json['kodeperusahaan'];
    namaperusahaan = json['namaperusahaan'];
    prosesopname = json['prosesopname'];
    email = json['email'];
    alamat = json['alamat'];
    kota = json['kota'];
    propinsi = json['propinsi'];
    negara = json['negara'];
    kodepos = json['kodepos'];
    telp = json['telp'];
    fax = json['fax'];
    npwp = json['npwp'];
    catatan = json['catatan'];
    informasirekening = json['informasirekening'];
    userentry = json['userentry'];
    tglentry = json['tglentry'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idperusahaan'] = this.idperusahaan;
    data['kodeperusahaan'] = this.kodeperusahaan;
    data['namaperusahaan'] = this.namaperusahaan;
    data['prosesopname'] = this.prosesopname;
    data['email'] = this.email;
    data['alamat'] = this.alamat;
    data['kota'] = this.kota;
    data['propinsi'] = this.propinsi;
    data['negara'] = this.negara;
    data['kodepos'] = this.kodepos;
    data['telp'] = this.telp;
    data['fax'] = this.fax;
    data['npwp'] = this.npwp;
    data['catatan'] = this.catatan;
    data['informasirekening'] = this.informasirekening;
    data['userentry'] = this.userentry;
    data['tglentry'] = this.tglentry;
    data['status'] = this.status;
    return data;
  }
}
