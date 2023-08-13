class ApiService {
  static const String baseUrl = "http://192.168.81.181/api/api_modify.php?what=";
  // static const String baseUrl =
  //     "http://192.168.51.237/api/api_modify.php?what=";
  // static const String baseUrl =
  //     "https://tnpdeveloper.000webhostapp.com/api/api_modify.php?what=";

  // Sessions Links
  static const String getSessionDetails = "${baseUrl}getsessiondetails";
  static const String addSessionDetails = "${baseUrl}insertsession";
  static const String deleteSessionDetails = "${baseUrl}deletesessiondetails";
  static const String updateDefaultBatchStatus = "${baseUrl}setdefaultsession";

  // Departments Links
  static const String getDepartmentDetails = "${baseUrl}get_department";
  static const String addDepartmentDetails = "${baseUrl}departmentdetails";
  static const String deleteDepartmentDetails = "${baseUrl}delete_department";

  // Sectors Links
  static const String getSectorDetails = "${baseUrl}get_sector";
  static const String addSectorDetails = "${baseUrl}sectordetails";
  static const String deleteSectorDetails = "${baseUrl}delete_sector";

  // Company Links
  static const String getCompanyDetails = "${baseUrl}getcompanydetails";
  static const String addCompanyDetails = "${baseUrl}companydetails";
  static const String deleteCompanyDetails = "${baseUrl}deletecompanydetails";

  // Hirings Links
  static const String getHiringsDetails = "${baseUrl}gethiringdetails";
  static const String deleteHiringsDetails = "${baseUrl}deletehiringdetails";

  // Users Links
  static const String getUserDetails = "${baseUrl}getuserdetails";
  static const String addUserDetails = "${baseUrl}insert_user";
  static const String updateUserDetails = "${baseUrl}updateuserdetails";
  static const String deleteUserDetails = "${baseUrl}deleteuserdetails";

  // Student Applications links
  static const String getAppliedCompanies = "${baseUrl}getappliedcompanies";
}
