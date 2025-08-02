class SopirModel {
  String? userbuat, idperusahaan, iddepo, idjabatan, idpegawai, kodepegawai, namapegawai, alamat, noidentitas, tempatlahir, tgllahir, hp, foto, pass, tokenfirebase, tgldownload, versiapp, login, catatan, userentry, tglentry, status, namajabatan;

  SopirModel({
    this.userbuat,
    this.idperusahaan,
    this.iddepo,
    this.idjabatan,
    this.idpegawai,
    this.kodepegawai,
    this.namapegawai,
    this.alamat,
    this.noidentitas,
    this.tempatlahir,
    this.tgllahir,
    this.hp,
    this.foto,
    this.pass,
    this.tokenfirebase,
    this.tgldownload,
    this.versiapp,
    this.login,
    this.catatan,
    this.userentry,
    this.tglentry,
    this.status,
    this.namajabatan,
  });

  factory SopirModel.fromJson(Map<String, dynamic> json) {
    return SopirModel(
      userbuat: json['userbuat'],
      idperusahaan: json['idperusahaan'],
      iddepo: json['iddepo'],
      idjabatan: json['idjabatan'],
      idpegawai: json['idpegawai'],
      kodepegawai: json['kodepegawai'],
      namapegawai: json['namapegawai'],
      alamat: json['alamat'],
      noidentitas: json['noidentitas'],
      tempatlahir: json['tempatlahir'],
      tgllahir: json['tgllahir'],
      hp: json['hp'],
      foto: json['foto'],
      pass: json['pass'],
      tokenfirebase: json['tokenfirebase'],
      tgldownload: json['tgldownload'],
      versiapp: json['versiapp'],
      login: json['login'],
      catatan: json['catatan'],
      userentry: json['userentry'],
      tglentry: json['tglentry'],
      status: json['status'],
      namajabatan: json['namajabatan'],
    );
  }
}
