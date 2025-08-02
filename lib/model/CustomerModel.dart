class CustomerModel {
  String? idperusahaan, idcustomer, kodecustomer, namacustomer, grandtotal, telp, alamat, latitude, longitude, latitudeabsen, longitudeabsen, tglcheckin, tglcheckout, catatanabsen, statuskunjungan, fotoabsen, namafotoabsen;

  CustomerModel({
    this.idperusahaan,
    this.idcustomer,
    this.kodecustomer,
    this.namacustomer,
    this.grandtotal,
    this.telp,
    this.alamat,
    this.latitude,
    this.longitude,
    this.latitudeabsen,
    this.longitudeabsen,
    this.tglcheckin,
    this.tglcheckout,
    this.catatanabsen,
    this.statuskunjungan,
    this.fotoabsen,
    this.namafotoabsen,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        idperusahaan: json['idperusahaan'].toString(),
        idcustomer: json['idcustomer'].toString(),
        kodecustomer: json['kodecustomer'].toString(),
        namacustomer: json['namacustomer'].toString(),
        grandtotal: json['grandtotal'].toString(),
        telp: json['telp'].toString(),
        alamat: json['alamat'].toString(),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
        latitudeabsen: json['latitudeabsen'].toString(),
        longitudeabsen: json['longitudeabsen'].toString(),
        tglcheckin: json['tglcheckin'].toString(),
        tglcheckout: json['tglcheckout'].toString(),
        catatanabsen: json['catatanabsen'].toString(),
        statuskunjungan: json['statuskunjungan'].toString(),
        fotoabsen: json['fotoabsen'].toString(),
        namafotoabsen: json['namafotoabsen'].toString(),
      );
}
