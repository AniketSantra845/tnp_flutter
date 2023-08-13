import 'package:placements/Models/Company_hirings/hirings.dart';
import 'package:placements/Models/company.dart';
import 'package:placements/Models/sessions.dart';

class ViewHirings {
  List<Hirings>? hiringDetails;
  List<Company>? companydetails;
  List<Session>? sessiondetails;
  ViewHirings({this.hiringDetails, this.companydetails, this.sessiondetails});

  ViewHirings.fromJson(Map<String, dynamic> json) {
    if (json['hirings'] != null) {
      // hiringDetails = <Hirings>[];
      json['hirings'].forEach((v) {
        hiringDetails!.add(new Hirings.fromJson(v));
      });
    }

    if (json['session'] != null) {
      sessiondetails = <Session>[];
      json['session'].forEach((v) {
        sessiondetails!.add(new Session.fromJson(v));
      });
    }

    if (json['companies'] != null) {
      companydetails = <Company>[];
      json['companies'].forEach((v) {
        companydetails!.add(new Company.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(ViewHirings instance) => <String, dynamic>{
        'hiringdetails': instance.hiringDetails,
        'companydetails': instance.companydetails,
        'sessiodetails': instance.sessiondetails,
      };

  // map(ViewHirings Function(dynamic e, dynamic f, dynamic g) param0) {}
}
