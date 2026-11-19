// ignore_for_file: constant_identifier_names

class LocalStorageKey {
  //!theme
  static const String THEME_KEY = "theme_key";
  static const String THEME_MODE_KEY = "theme_mode_key";
  //! validator
  static const String USER_TOKEN_KEY = "user_token_key"; //! bearer token
  //! user roll  (eg 1,2,3)
  static const String USER_ROLL_ID_KEY = "user_roll_id_key";

  static const String USER_EMP_ID_KEY = "user_employee_id_key";
  static const String USER_PROFILE_URL_KEY = "user_profile_url_key";

  static const String USER_DEPARTMENT_ID_KEY = "user_department_id_key";
  static const String USER_ROLL_NAME_KEY = "user_department_name_key";
  //! user roll type (eg sales executive, sales manager)
  static const String USER_ROLL_TYPE_KEY = "user_roll_type_key";
  static const String USER_ID_KEY = "user_id_key"; //! user id
  static const String USER_NAME_KEY = "user_name_key"; //! user name
  static const String USER_NUMBER_KEY = "user_number_key"; //! user number

  //* attendence
  static const String IS_MARKED_IN_TIME = "is_marked_in_time";
  static const String IS_MARKED_OUT_TIME = "is_marked_out_time";

  //* wifi restrict key
  static const String CONNECTED_WIFI_kEY = "connected_wifi_ip";
  static const String LAST_VALIDATIO_NkEY = "last_wifi_validation";
  static const String ALLOWED_WIFI_IPS = "allowed_wifi_ips";

  // Preconfigured Employee / Offline Caching
  static const String EMPLOYEE_PROFILE = "cached_employee_profile";

  // Attendance
  static const String TODAY_ATTENDANCE = "cached_today_attendance";
  static const String ATTENDANCE_HISTORY = "cached_attendance_history";
  static const String PENDING_ATTENDANCE_EVENTS = "pending_attendance_events";

  // Leave
  static const String LEAVE_BALANCE = "cached_leave_balance";
  static const String LEAVE_REQUESTS = "cached_leave_requests";

  // Office Config & Simulation
  static const String OFFICE_CONFIG = "office_config";
  static const String SIMULATION_MODE = "simulation_mode";
}
