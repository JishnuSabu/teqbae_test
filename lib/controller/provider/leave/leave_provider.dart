import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqbae_test/controller/service/leave/leave_service.dart';
import 'package:teqbae_test/core/network/api_response.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/model/leave/leave_balance_model.dart';
import 'package:teqbae_test/model/leave/leave_request_model.dart';

class LeaveSubmissionResult {
  final bool isSuccess;
  final String message;

  LeaveSubmissionResult({required this.isSuccess, required this.message});
}

class LeaveProvider extends ChangeNotifier {
  LeaveBalanceModel _leaveBalance = LeaveBalanceModel.empty();
  List<LeaveRequestModel> _leaveRequests = [];

  ApiResponse<List<LeaveRequestModel>> leaveRequestsResponse =
      ApiResponse.initial();

  // Form Fields
  String _selectedLeaveType = 'Casual';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController reasonController = TextEditingController();
  bool _isSubmitting = false;

  // Getters
  LeaveBalanceModel get leaveBalance => _leaveBalance;
  List<LeaveRequestModel> get leaveRequests => _leaveRequests;
  String get selectedLeaveType => _selectedLeaveType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isSubmitting => _isSubmitting;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  List<LeaveRequestModel> get filteredLeaveRequests {
    if (_selectedFilter == 'All') return _leaveRequests;
    return _leaveRequests
        .where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  int get requestedDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  LeaveProvider() {
    _loadFromCache();
  }

  void _loadFromCache() {
    final cachedBal = LocalStorageService.getLeaveBalance();
    if (cachedBal != null) _leaveBalance = cachedBal;

    final cachedReqs = LocalStorageService.getLeaveRequests()
        .where((r) => r.id != 'req-001' && r.id != 'req-002')
        .toList();
    _leaveRequests = cachedReqs;
  }

  void setLeaveType(String type) {
    _selectedLeaveType = type;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      _endDate = _startDate;
    }
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();

  void onReasonChanged(String val) {
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void clearForm() {
    _selectedLeaveType = 'Casual';
    _startDate = null;
    _endDate = null;
    reasonController.clear();
    notifyListeners();
  }

  /// Fetch real leave balance and real requests from backend APIs
  Future<void> fetchLeaveData() async {
    leaveRequestsResponse = ApiResponse.loading();
    notifyListeners();

    // Load from cache first for instant offline/cached viewing
    _loadFromCache();

    try {
      final results = await Future.wait([
        LeaveService.getLeaveBalance(),
        LeaveService.getLeaveRequests(),
      ]);

      final bal = results[0] as LeaveBalanceModel?;
      if (bal != null) {
        _leaveBalance = bal;
        await LocalStorageService.saveLeaveBalance(_leaveBalance);
      }

      final rawRequests = results[1] as List<LeaveRequestModel>?;
      if (rawRequests != null) {
        final requests = rawRequests
            .where((r) => r.id != 'req-001' && r.id != 'req-002')
            .toList();
        final serverIds = requests.map((r) => r.id).toSet();
        final localOnly =
            _leaveRequests.where((r) => !serverIds.contains(r.id)).toList();
        _leaveRequests = [...requests, ...localOnly];
        await LocalStorageService.saveLeaveRequests(_leaveRequests);
      }

      leaveRequestsResponse = ApiResponse.success(_leaveRequests);
    } catch (e) {
      log("LeaveProvider fetchLeaveData error: $e");
      _loadFromCache();
      leaveRequestsResponse = ApiResponse.error(
        _leaveRequests.isNotEmpty
            ? "Offline Mode: Showing cached leave requests"
            : "Failed to load leave requests: $e",
      );
    } finally {
      notifyListeners();
    }
  }

  /// Client-side validation based on assignment rules
  String? validateForm() {
    if (_startDate == null) {
      return "Please select a start date.";
    }
    if (_endDate == null) {
      return "Please select an end date.";
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedStartDay =
        DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final selectedEndDay =
        DateTime(_endDate!.year, _endDate!.month, _endDate!.day);

    // Rule 1: Start date cannot be before current company date
    if (selectedStartDay.isBefore(today)) {
      return "Start date cannot be before the current company date.";
    }

    // Rule 2: End date cannot be before start date
    if (selectedEndDay.isBefore(selectedStartDay)) {
      return "End date cannot be before the start date.";
    }

    // Rule 3: Reason must contain at least 10 non-whitespace characters
    final reasonText = reasonController.text;
    final nonWhitespaceCount = reasonText.replaceAll(RegExp(r'\s'), '').length;
    if (nonWhitespaceCount < 10) {
      return "Reason must contain at least 10 non-whitespace characters (currently $nonWhitespaceCount).";
    }

    // Rule 4: Requested days cannot exceed available balance (if balance is populated)
    final days = requestedDays;
    final available = _selectedLeaveType.toLowerCase() == 'casual'
        ? _leaveBalance.casual
        : _leaveBalance.sick;

    if (_leaveBalance.total > 0 && days > available) {
      return "Requested $days day(s) exceeds your available $_selectedLeaveType balance ($available day(s)).";
    }

    // Rule 5: Check overlapping dates against existing leaves
    for (final existing in _leaveRequests) {
      if (existing.status.toLowerCase() == 'rejected') continue;
      try {
        final existingStart = DateTime.parse(existing.startDate);
        final existingEnd = DateTime.parse(existing.endDate);

        final exStartDay = DateTime(
          existingStart.year,
          existingStart.month,
          existingStart.day,
        );
        final exEndDay = DateTime(
          existingEnd.year,
          existingEnd.month,
          existingEnd.day,
        );

        if (!selectedEndDay.isBefore(exStartDay) &&
            !selectedStartDay.isAfter(exEndDay)) {
          return "Selected dates overlap with an existing ${existing.status} request from ${existing.startDate} to ${existing.endDate}.";
        }
      } catch (_) {}
    }

    return null;
  }

  /// Submit leave application via real API
  Future<LeaveSubmissionResult> submitLeaveApplication() => submitLeaveRequest();

  Future<LeaveSubmissionResult> submitLeaveRequest() async {
    final validationError = validateForm();
    if (validationError != null) {
      return LeaveSubmissionResult(isSuccess: false, message: validationError);
    }

    _isSubmitting = true;
    notifyListeners();

    final startDateStr = DateFormat('yyyy-MM-dd').format(_startDate!);
    final endDateStr = DateFormat('yyyy-MM-dd').format(_endDate!);

    try {
      final response = await LeaveService.submitLeaveRequest({
        'leave_type': _selectedLeaveType,
        'start_date': startDateStr,
        'end_date': endDateStr,
        'days': requestedDays,
        'reason': reasonController.text.trim(),
      });

      _isSubmitting = false;
      notifyListeners();

      if (response != null && response['status'] == true) {
        clearForm();
        if (response['request'] is Map<String, dynamic>) {
          final newReq = LeaveRequestModel.fromJson(
              response['request'] as Map<String, dynamic>);
          _leaveRequests.removeWhere((r) => r.id == newReq.id);
          _leaveRequests.insert(0, newReq);
          await LocalStorageService.saveLeaveRequests(_leaveRequests);
        }
        await fetchLeaveData();
        return LeaveSubmissionResult(
          isSuccess: true,
          message: response['message']?.toString() ??
              "Leave application submitted successfully.",
        );
      } else {
        return LeaveSubmissionResult(
          isSuccess: false,
          message:
              response?['message']?.toString() ?? "Failed to submit leave request.",
        );
      }
    } on DioException catch (dioErr) {
      _isSubmitting = false;
      notifyListeners();
      final msg = dioErr.response?.data is Map
          ? (dioErr.response!.data['message']?.toString() ?? dioErr.message)
          : dioErr.message;
      return LeaveSubmissionResult(
        isSuccess: false,
        message: msg ?? "Failed to submit leave application.",
      );
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return LeaveSubmissionResult(
        isSuccess: false,
        message: "Failed to submit leave application: ${e.toString()}",
      );
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}
