class Company {
  int id;
  String cif;
  String name;
  String about;
  String contact;
  String? alt_contact;
  String email;
  String? alt_email;

  Company({
    this.id = 0,
    required this.cif,
    required this.name,
    required this.about,
    required this.contact,
    this.alt_contact,
    required this.email,
    this.alt_email,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      cif: json['cif'] ?? '',
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      contact: json['contact'] ?? '',
      alt_contact: json['alt_contact'],
      email: json['email'] ?? '',
      alt_email: json['alt_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cif': cif,
      'name': name,
      'about': about,
      'contact': contact,
      'alt_contact': alt_contact,
      'email': email,
      'alt_email': alt_email,
    };
  }
}
