class Users {
  int? id;
  String? name;
  String? email;
  String? password;
  int? role;

  Users({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] != null ? int.parse(json['role']) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

class UsersFromDBToUI extends Users {
  String? department;
  String? label;

  UsersFromDBToUI({
    int? id,
    this.department,
    this.label,
    String? name,
    String? email,
    String? password,
    int? role,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          role: role,
        );

  factory UsersFromDBToUI.fromJson(Map<String, dynamic> json) {
    return UsersFromDBToUI(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      label: json['label'] ?? '',
      department: json['department'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] != null ? int.parse(json['role']) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'department': department,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

class UserFromUIToDB extends Users {
  int session_id;
  int department_id;

  UserFromUIToDB({
    int? id,
    required this.session_id,
    required this.department_id,
    String? name,
    String? email,
    String? password,
    int? role,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          role: role,
        );

  factory UserFromUIToDB.fromJson(Map<String, dynamic> json) {
    return UserFromUIToDB(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      session_id: json['session_id'] != null
          ? int.tryParse(json['session_id'].toString()) ?? 0
          : 0,
      department_id: json['department_id'] != null
          ? int.tryParse(json['department_id'].toString()) ?? 0
          : 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      role:
          json['role'] != null ? int.tryParse(json['role'].toString()) ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': session_id,
      'department_id': department_id,
      'name': name,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}
