// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:placements/Controllers/company_controller.dart';
import 'package:placements/Controllers/department_controller.dart';
import 'package:placements/Controllers/sector_controller.dart';
import 'package:placements/Controllers/session_controller.dart';
import 'package:placements/Models/Company_hirings/ui_to_db_hirings.dart';
import 'package:placements/Models/company.dart';
import 'package:placements/Models/departments.dart';
import 'package:placements/Models/sector.dart';
import 'package:placements/Models/sessions.dart';

import '../../../Models/Company_hirings/hirings.dart';
import '../../../Shared Docs/Common Widgets/error_dialog.dart';

class AddCompanyHiringDetails extends StatefulWidget {
  final Hirings ? hiring;
  const AddCompanyHiringDetails({super.key, this.hiring});

  @override
  State<AddCompanyHiringDetails> createState() =>
      _AddCompanyHiringDetailsState();
}

class _AddCompanyHiringDetailsState extends State<AddCompanyHiringDetails> {
  final _formKey = GlobalKey<FormState>();

  List<Session> _sessions = [];
  List<Company> _company = [];
  List<Departments> _departments = [];
  List<Sectors> _sectors = [];

    int? _id;
    int? _company_id;
    int? _session_id;
    int? _department_id;
    int? _sector_id;
    String? _designation;
    String? _bond;
    String? _bond_condition;
    String? _min_stipend;
    String? _max_stipend;
    String? _minimum_package;
    String? _maximum_package;
    String? _bonus;
    String? _performance_inc;
    String? _joblocation;
    String? _joindate;
    String? _startdate;
    String? _enddate;
    String? _interview_mode;
    String? _interview_location;
    String? _other_requirement;

    final bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _id = widget.hiring?.id ?? 0;
    // _sessionId = widget.user?.session_id ?? 0;
    // _departmentId = widget.user?.department_id ?? 0;
    // _userName = widget.hiring?.name ?? '';
    // _password = widget.hiring?.password ?? '';
    // _email = widget.hiring?.email ?? '';

    fetchSessions();
    fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> fetchSessions() async {
    try {
      final sessions = await SessionController().getSessions();
      print(sessions);
      setState(() {
        _sessions = sessions;
      });
    } catch (e) {
      print('Error fetching sessions: $e'); // Add this line
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch sessions: $e',
          );
        },
      );
    }
  }

  Future<void> fetchCompany() async {
    try {
      final companies = await CompanyController().getCompanies();
      setState(() {
        _company = companies;
      });
    } catch (e) {
      print('Error fetching companies: $e'); // Add this line
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch companies: $e',
          );
        },
      );
    }
  }

  Future<void> fetchDepartments() async {
    try {
      final departments = await DepartmentController().getDepartments();
      print(departments);
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      print('Error fetching department: $e'); // Add this line
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch department: $e',
          );
        },
      );
    }
  }

  Future<void> fetchSectors() async {
    try {
      final sectors = await SectorController().getSectors();
      setState(() {
        _sectors = sectors;
      });
    } catch (e) {
      print('Error fetching sectors: $e'); // Add this line
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: 'Failed to fetch sectors: $e',
          );
        },
      );
    }
  }
}
