class Session {
  int id;
  DateTime start_date;
  DateTime end_date;
  String label;
  int? default_year;
  int? status;

  Session({
    this.id = 0,
    required this.start_date,
    required this.end_date,
    required this.label,
    this.default_year = 0,
    this.status = 0,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      start_date: DateTime.parse(json['start_date']),
      end_date: DateTime.parse(json['end_date']),
      label: json['label'] ?? '',
      default_year:
          json['default_year'] != null ? int.parse(json['default_year']) : 0,
      status: json['status'] != null ? int.parse(json['status']) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
      'label': label,
      'default_year': default_year,
      'status': status,
    };
  }
}
