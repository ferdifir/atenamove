class UserModel {
  String? iduser, kodeuser, username, pass, jabatan, iddepo, namadepo, toleransijarak, idperusahaan, namaperusahaan, tokenfirebase, login;

  UserModel({this.iduser, this.kodeuser, this.username, this.pass, this.jabatan, this.iddepo, this.namadepo, this.toleransijarak, this.idperusahaan, this.namaperusahaan, this.tokenfirebase, this.login});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      iduser: json['iduser'],
      kodeuser: json['kodeuser'],
      username: json['username'],
      pass: json['pass'],
      jabatan: json['jabatan'],
      iddepo: json['iddepo'],
      namadepo: json['namadepo'],
      toleransijarak: json['toleransijarak'],
      idperusahaan: json['idperusahaan'],
      namaperusahaan: json['namaperusahaan'],
      tokenfirebase: json['tokenfirebase'],
      login: json['login'],
    );
  }
}
