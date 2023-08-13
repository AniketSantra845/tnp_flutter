class Departments {
  int id;
  String department;
  String? remarks;

  Departments({
    this.id = 0,
    required this.department,
    this.remarks,
  });

  factory Departments.fromJson(Map<String, dynamic> json) {
    return Departments(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      department: json['department'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
      'remarks': remarks,
    };
  }
}
