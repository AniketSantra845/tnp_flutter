class Ui_to_db_hirings {
  int id;
  int company_id;
  int session_id;
  int departmet_id;
  int sector_id;
  String designation;
  String bond;
  String bond_condition;
  String min_stipend;
  String max_stipend;
  String minimum_package;
  String maximum_package;
  String bonus;
  String performance_inc;
  String joblocation;
  String joindate;
  String startdate;
  String enddate;
  String interview_mode;
  String interview_location;
  String other_requirement;

  Ui_to_db_hirings(
      {this.id = 0,
      required this.company_id,
      required this.session_id,
      required this.departmet_id,
      required this.sector_id,
      required this.designation,
      required this.bond,
      required this.bond_condition,
      required this.min_stipend,
      required this.max_stipend,
      required this.minimum_package,
      required this.maximum_package,
      required this.bonus,
      required this.performance_inc,
      required this.joblocation,
      required this.joindate,
      required this.startdate,
      required this.enddate,
      required this.interview_mode,
      required this.interview_location,
      required this.other_requirement});

  factory Ui_to_db_hirings.fromJson(Map<String, dynamic> json) {
    return Ui_to_db_hirings(
        id: json['id'] != null ? int.parse(json['id']) : 0,
        company_id:
            json['company_id'] != null ? int.parse(json['company_id']) : 0,
        session_id:
            json['session_id'] != null ? int.parse(json['session_id']) : 0,
        departmet_id:
            json['departmet_id'] != null ? int.parse(json['departmet_id']) : 0,
        sector_id: json['sector_id'] != null ? int.parse(json['sector_id']) : 0,
        designation: json['designation'] ?? '',
        bond: json['bond'] ?? '',
        bond_condition: json['bond_condition'] ?? '',
        min_stipend: json['min_stipend'] ?? '',
        max_stipend: json['max_stipend'] ?? '',
        minimum_package: json['minimum_package'] ?? '',
        maximum_package: json['maximum_package'] ?? '',
        bonus: json['bonus'] ?? '',
        performance_inc: json['performance_inc'] ?? '',
        joblocation: json['joblocation'] ?? '',
        joindate: json['joindate'] ?? '',
        startdate: json['startdate'] ?? '',
        enddate: json['enddate'] ?? '',
        interview_mode: json['interview_mode'] ?? '',
        interview_location: json['interview_location'] ?? '',
        other_requirement: json['other_requirement'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': company_id,
      'session_id': session_id,
      'department_id': departmet_id,
      'sector_id': sector_id,
      'designation': designation,
      'bond': bond,
      'bond_condition': bond_condition,
      'min_stipend': min_stipend,
      'max_stipend': max_stipend,
      'minimum_package': minimum_package,
      'maximum_package': maximum_package,
      'bonus': bonus,
      'performance_inc': performance_inc,
      'joblocation': joblocation,
      'joindate': joindate,
      'startdate': startdate,
      'enddate': enddate,
      'interview_mode': interview_mode,
      'interview_location': interview_location,
      'other_requirement': other_requirement
    };
  }
}
