class PendingList {

  int? hiring_id;
  int? id; // student_id
  int? session_id;
  int? user_id;
  int? department_id;
  String? surname;
  String? first_name;
  String? last_name;
  String? enrollment;
  String? gender ;
  String? contact ;
  String? dob;
  String? adhaar;
  String? pan ;

  PendingList({
  this.hiring_id,
  this.id, // student_id
  this.session_id,
  this.user_id,
  this.department_id,
  this.surname,
  this.first_name,
  this.last_name,
  this.enrollment,
  this.gender,
  this.contact,
  this.dob,
  this.adhaar,
  this.pan,
  });

  factory PendingList.fromJson(Map<String, dynamic> json) {
    return PendingList(
      id: json['id'] != null ? int.parse(json['id']) : 0, // student_id
      hiring_id: json['hiring_id'] != null ? int.parse(json['hiring_id']) : 0,
      session_id: json['session_id'] != null ? int.parse(json['session_id']) : 0,
      user_id: json['user_id'] != null ? int.parse(json['user_id']) : 0,
      department_id: json['department_id'] != null ? int.parse(json['department_id']) : 0,
      surname: json['surname'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      enrollment: json['enrollment'] ?? '',
      gender: json['gender'] ?? '',
      contact: json['contact'] ?? '',
      dob: json['dob'] ?? '',
      adhaar: json['adhaar'] ?? '',
      pan: json['pan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hiring_id': hiring_id,
      'session_id':session_id,
      'user_id':user_id,
      'department_id':department_id,
      'surname':surname,
      'first_name':first_name,
      'last_name':last_name,
      'enrollment':enrollment,
      'gender':gender,
      'contact':contact,
      'dob':dob,
      'adhaar':adhaar,
      'pan':pan,
    };
  }
}