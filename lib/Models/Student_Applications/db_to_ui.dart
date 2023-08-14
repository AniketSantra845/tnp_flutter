class StudentApplicationDbToUi {
  int? id;
  int? hiring_id;
  String? cif;
  String? name;
  String? about;
  String? contact;
  String? alt_contact;
  String? designation;
  String? status;
  String? joblocation;

  StudentApplicationDbToUi({
    this.id,
    this.hiring_id,
    this.cif,
    this.name,
    this.about,
    this.contact,
    this.alt_contact,
    this.designation,
    this.status,
    this.joblocation,
  });

  factory StudentApplicationDbToUi.fromJson(Map<String, dynamic> json) {
    return StudentApplicationDbToUi(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      hiring_id: json['hid'] != null ? int.parse(json['hid']) : 0,
      cif: json['cif'] ?? 0,
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      contact: json['contact'] ?? '',
      alt_contact: json['alt_contact'] ?? '',
      designation: json['designation'] ?? '',
      status: json['status'] ?? '',
      joblocation: json['joblocation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hiring_id': hiring_id,
      'cif': cif,
      'name': name,
      'about': about,
      'contact': contact,
      'alt_contact': alt_contact,
      'designation': designation,
      'status': status,
      'joblocation': joblocation,
    };
  }
}
