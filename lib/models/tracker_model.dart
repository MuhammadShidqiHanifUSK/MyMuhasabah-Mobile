class TrackerModel {
  final int id;
  final int userId;
  final String tanggal;

  // Sholat Wajib
  final String? shubuh;
  final String? dzuhur;
  final String? ashar;
  final String? maghrib;
  final String? isya;

  // Sholat Sunnah
  final bool sunnahQabliyahShubuh;
  final bool sunnahQabliyahDzuhur;
  final bool sunnahBadiyahDzuhur;
  final bool sunnahQabliyahAshar;
  final bool sunnahQabliyahMaghrib;
  final bool sunnahBadiyahMaghrib;
  final bool sunnahQabliyahIsya;
  final bool sunnahBadiyahIsya;
  final bool tahajud;
  final bool dhuha;
  final bool witir;

  // Amalan Kebaikan
  final int tilawah;
  final bool dzikirPagi;
  final bool dzikirPetang;
  final bool puasaSunnah;
  final bool sedekah;
  final bool membantuOrang;
  final bool silaturahmi;

  // Amal Keburukan
  final bool berkataKotor;
  final bool berbohong;
  final bool ghibah;
  final bool berkataKasar;
  final bool merokok;
  final bool begadangSiasia;
  final bool scrollingBerlebihan;
  final bool marahBerlebihan;
  final bool iriDengki;
  final bool sombong;

  TrackerModel({
    required this.id,
    required this.userId,
    required this.tanggal,
    this.shubuh,
    this.dzuhur,
    this.ashar,
    this.maghrib,
    this.isya,
    required this.sunnahQabliyahShubuh,
    required this.sunnahQabliyahDzuhur,
    required this.sunnahBadiyahDzuhur,
    required this.sunnahQabliyahAshar,
    required this.sunnahQabliyahMaghrib,
    required this.sunnahBadiyahMaghrib,
    required this.sunnahQabliyahIsya,
    required this.sunnahBadiyahIsya,
    required this.tahajud,
    required this.dhuha,
    required this.witir,
    required this.tilawah,
    required this.dzikirPagi,
    required this.dzikirPetang,
    required this.puasaSunnah,
    required this.sedekah,
    required this.membantuOrang,
    required this.silaturahmi,
    required this.berkataKotor,
    required this.berbohong,
    required this.ghibah,
    required this.berkataKasar,
    required this.merokok,
    required this.begadangSiasia,
    required this.scrollingBerlebihan,
    required this.marahBerlebihan,
    required this.iriDengki,
    required this.sombong,
  });

  factory TrackerModel.fromJson(Map<String, dynamic> json) {
    return TrackerModel(
      id: json['id'],
      userId: json['user_id'],
      tanggal: json['tanggal'],
      shubuh: json['shubuh'],
      dzuhur: json['dzuhur'],
      ashar: json['ashar'],
      maghrib: json['maghrib'],
      isya: json['isya'],
      sunnahQabliyahShubuh: json['sunnah_qabliyah_shubuh'] ?? false,
      sunnahQabliyahDzuhur: json['sunnah_qabliyah_dzuhur'] ?? false,
      sunnahBadiyahDzuhur: json['sunnah_badiyah_dzuhur'] ?? false,
      sunnahQabliyahAshar: json['sunnah_qabliyah_ashar'] ?? false,
      sunnahQabliyahMaghrib: json['sunnah_qabliyah_maghrib'] ?? false,
      sunnahBadiyahMaghrib: json['sunnah_badiyah_maghrib'] ?? false,
      sunnahQabliyahIsya: json['sunnah_qabliyah_isya'] ?? false,
      sunnahBadiyahIsya: json['sunnah_badiyah_isya'] ?? false,
      tahajud: json['tahajud'] ?? false,
      dhuha: json['dhuha'] ?? false,
      witir: json['witir'] ?? false,
      tilawah: json['tilawah'] ?? 0,
      dzikirPagi: json['dzikir_pagi'] ?? false,
      dzikirPetang: json['dzikir_petang'] ?? false,
      puasaSunnah: json['puasa_sunnah'] ?? false,
      sedekah: json['sedekah'] ?? false,
      membantuOrang: json['membantu_orang'] ?? false,
      silaturahmi: json['silaturahmi'] ?? false,
      berkataKotor: json['berkata_kotor'] ?? false,
      berbohong: json['berbohong'] ?? false,
      ghibah: json['ghibah'] ?? false,
      berkataKasar: json['berkata_kasar'] ?? false,
      merokok: json['merokok'] ?? false,
      begadangSiasia: json['begadang_siasia'] ?? false,
      scrollingBerlebihan: json['scrolling_berlebihan'] ?? false,
      marahBerlebihan: json['marah_berlebihan'] ?? false,
      iriDengki: json['iri_dengki'] ?? false,
      sombong: json['sombong'] ?? false,
    );
  }
}