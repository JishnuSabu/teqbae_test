class Endpoints {
  // Suggested Mock Endpoints (Section 5)
  static const String employeeMe = '/employee/me';
  static const String attendance = '/attendance';
  static const String attendanceEvents = '/attendance/events';
  static const String leaveBalance = '/leave/balance';
  static const String leaveRequests = '/leave/requests';

  // Reviewer simulation controls
  static const String reviewerScenario = '/reviewer/scenario';
  static const String reviewerReset = '/reviewer/reset';

  //! common
  //* fcm
  static const String fcmToken = 'save-fcm-token';
  //* auth
  static const String login = 'auth/login';

  //* change pswrd
  static const String changePswrd = 'auth/change-password';
  static const String forgotPswrdOtpRequest = 'auth/forgot-password';
  static const String resetPswrd = 'auth/reset-password';
  static const String resetOtp = 'auth/resend-otp';

  //leave
  static const String leaveRequest = 'leaves/apply';
  static const String leaveList = '/leaves/list';
  static const String leaveDelete = '/leaves/';
  static const String managerLeaveApprovalList = 'leave-list';
  static const String managerLeaveApproval = 'leave/update';
  static const String hrManagerLeaveApplyList = 'hrmanager/teammanager/leaves';
  static const String hrManagerLeaveApproval = 'leaves/teammanager/approve';
  static const String leaveCategoryList = 'leave-categorieslist';
  static const String leaveCategoryListCount = 'leave-month-wise-count';
  static const String hrLeaverequestCount = 'hrmanager/leaves/count';

  //attendance
  static const String checkInCheckOut = 'attendances/check-in-out';
  static const String checkInCheckOutDetails = 'attendances/list';
  static const String attendanceSummary = 'attendances/summary';
  static const String recentAttendanceActivity =
      'attendances/recent-activities';
  static const String attendanceStatus = 'attendance/status';

  //Expenses
  static const String expenseCategory = 'expense-categories/list';
  static const String addExpense = 'add/expenses';
  static const String expenseList = 'expenses/list';
  static const String expenseSummary = 'expenses/summary';
  static const String expenseDelete = 'expenses/';
  static const String expenseApprovalList = 'manager/expenses/list';
  static const String expenseApproval = 'manager/expenses/approve/';
  static const String hrmanagerexpenseapprovelist = 'hrmanager/expenseshr/list';
  static const String hrmanagerexpenseapproval = 'hrmanager/expenseshr/approve';

  //Payroll
  static const String payRollCurrentMonthData = 'payslips/current-month';
  static const String payRollList = 'payslips/list';
  static const String paySlipDetails = 'payslips/';

  //Settings
  static const String employeeProfileInfo = 'employees/profile/info';
  static const String updateProfilePicture = 'profile-picture';

  //help
  static const String departmentsList = 'departments/list';
  static const String helpTicketCreate = 'add/help-tickets';
  static const String helpTicketList = 'help-tickets/list';

  //announcement
  static const String announcementList = 'announcements/list';
  static const String managerAnnouncementCreate = 'manager/add/announcements';

  //calender
  static const String holidays = 'holidays/list';
}
