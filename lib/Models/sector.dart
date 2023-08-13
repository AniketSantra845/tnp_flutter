class Sectors {
  int id;
  String sector;
  String? remarks;

  Sectors({
    this.id = 0,
    required this.sector,
    this.remarks,
  });

  factory Sectors.fromJson(Map<String, dynamic> json) {
    return Sectors(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      sector: json['sector'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sector': sector,
      'remarks': remarks,
    };
  }
}
