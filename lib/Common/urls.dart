class Api {
  static const _baseUrl =
      "http://ec2-3-17-49-176.us-east-2.compute.amazonaws.com:";
  //'http://ec2-18-221-213-222.us-east-2.compute.amazonaws.com:';

  static const loginApi = _baseUrl + '1280/api/Doctor';

  static const otpApi = _baseUrl + '1180/connect/token';

  static const getUserProfileApi = _baseUrl + '1280/api/Doctor/';

  static const uploadImageApi = _baseUrl + '1480/api/File';

  static const getUploadImageApi = _baseUrl + '1480/api/File/';

  static const postDoctorDetailApi = _baseUrl + '1280/api/Doctor/';

  static const getAllDepartmentApi = _baseUrl + '1780/api/Department/all';

  static const getAllCouncilApi = _baseUrl + '1780/api/Council/all';

  static const getAllDegreesApi = _baseUrl + '1780/api/Qualification/all';

  static const fetchClinicDataApi = _baseUrl + '1880/api/Clinic/all';

  static const addClinicApi = _baseUrl + '1880/api/Clinic';

  static const deleteClinicapi = _baseUrl + '1880/api/Clinic/';

  static const editClinicApi = _baseUrl + '1880/api/Clinic/';

  static const applyLeaveApi = _baseUrl + '1380/api/Leave';

  static const fetchLeaveDataApi = _baseUrl + '1380/api/Leave';

  static const deleteLeaveapi = _baseUrl + '1380/api/Leave/';

  static const updateLeaveapi = _baseUrl + '1380/api/Leave/';

  static const fetchBookingsApi = _baseUrl + '1380/api/Calendar';

  static const postCalendarApi = _baseUrl + '1380/api/Calendar';

  static const getAreaByPincode = _baseUrl + '1780/api/Location/search/';

  static const deleteBookingapi = _baseUrl + '1380/api/Calendar/';

  static const putCalendarApi = _baseUrl + '1380/api/Calendar/';

  static const dashboardLeaveData = _baseUrl + '1380/api/Statistics?';
}
