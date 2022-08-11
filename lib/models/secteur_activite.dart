class Secteur{
  

late String code;
late String libelle;

Secteur({required this.code, required this.libelle});

 factory Secteur.fromJson(dynamic json) {
    return Secteur(code: json['code'] as String, libelle: json['libelle'] as String);
 }
}