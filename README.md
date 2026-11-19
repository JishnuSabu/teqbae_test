# Flutter Developer Assignment — REBS HRMS
## Offline-Capable Employee Workspace

A production-grade, offline-first Flutter mobile application for employee attendance tracking and leave management, fulfilling all requirements of the **REBS HRMS Machine Test**.

Built with Flutter and Dart, Clean Architecture, Provider state management, and an embedded local mock HTTP server.

---

## 📋 Comprehensive Requirements Traceability Matrix

| Requirement | PDF Section | Status | Implementation Details |
| :--- | :--- | :--- | :--- |
| **Employee Dashboard** | Sec. 1 | ✅ Completed | Name, ID, Dept, Today status, Check-In/Out times, Live elapsed duration timer, Leave balances, Latest 5 attendance logs, Shimmer loading, Offline notice. |
| **Attendance Check-In & Check-Out** | Sec. 2 | ✅ Completed | 1 check-in per day, check-out only after check-in, double-tap prevention lock (`isProcessingAction`), timestamp & GPS capture. |
| **Geofencing (200m)** | Sec. 2 | ✅ Completed | Haversine distance formula $\le 200\text{m}$. Clear feedback dialog with exact calculated distance if outside. Configurable office coordinates & simulation modes. |
| **Offline Storage & Caching** | Sec. 3 | ✅ Completed | Dashboard profile, today's status, attendance history, and leave requests cached locally via `LocalStorageService` (`SharedPreferences`). |
| **Offline Action Queuing** | Sec. 3 | ✅ Completed | Valid offline check-ins/check-outs are saved locally in a FIFO queue. |
| **Event State Distinction** | Sec. 3 | ✅ Completed | `Pending Sync` (amber badge & count), `Synced` (green confirmed badge), and `Rejected` (red conflict badge). |
| **Persistence Across Restart** | Sec. 3 | ✅ Completed | Pending events queue and today's attendance state are persisted to disk; fully restored upon app relaunch. |
| **Manual "Sync Now"** | Sec. 3 | ✅ Completed | Located in the **Settings** screen on `SyncStatusBanner` with real-time feedback and concurrency lock. |
| **Auto-Sync on Connectivity Return** | Sec. 3 | ✅ Completed | `SyncService.initConnectivityMonitor()` monitors network changes via `connectivity_plus` and auto-dispatches pending events when back online. |
| **Ordering Preservation (FIFO)** | Sec. 3 | ✅ Completed | Events sorted by ascending timestamp; `check_in` always processes before `check_out`. Batch halts on network errors to preserve order. |
| **Server Conflict Handling** | Sec. 3 | ✅ Completed | Handles HTTP 409 conflict: marks event as rejected and removes from queue so it does not block the pipeline. |
| **Timeout & Idempotency** | Sec. 3 | ✅ Completed | Client generates unique `idempotencyKey` (`evt_<timestamp>_<microseconds>`). On timeout, event remains in queue and retries with the identical key without producing duplicate records. |
| **Leave Application Form** | Sec. 4 | ✅ Completed | Leave Type (Casual/Sick), Start Date, End Date, Reason. |
| **Leave Validations (6 Rules)** | Sec. 4 | ✅ Completed | Start date $\ge$ today, End date $\ge$ start date, Reason $\ge$ 10 non-whitespace chars, Requested days $\le$ available balance, Overlapping dates check, All calendar days count. |
| **Leave Offline History & Status** | Sec. 4 | ✅ Completed | Shows Pending, Approved, and Rejected requests. Cached for offline viewing. Online submission requirement. |
| **Local Mock HTTP API** | Sec. 5 | ✅ Completed | In-process server on `http://127.0.0.1:8085` (`MockHttpServer`). Endpoints: `GET /employee/me`, `GET /attendance?month=YYYY-MM`, `POST /attendance/events`, `GET /leave/balance`, `GET /leave/requests`, `POST /leave/requests`. |
| **Repeatable Mock Scenarios** | Sec. 5 | ✅ Completed | Switchable at runtime via **Settings > Mock API Scenarios**: Normal (200 OK), Slow responses (4s), Timeouts (35s), Server errors (500), Duplicate conflicts (409), Leave rejection (422), Reset data. |
| **HTTP Client Usage** | Sec. 5 | ✅ Completed | Communication occurs via `DioClient` over HTTP; data is never hardcoded directly into widgets. |

---

## 1. Architecture & Design

```
lib/
├── core/
│   ├── constants/          # ConstSvgIcons, ConstImages
│   ├── network/            # DioClient, Endpoints, BaseUrl, MockHttpServer
│   ├── routes/             # AppRouter (Dashboard, Leave, Leave Apply, Settings, Profile)
│   ├── services/           # LocationService (GPS & Haversine), LocalStorageService
│   ├── sync/               # SyncService (FIFO sync engine, connectivity monitor)
│   ├── themes/             # ColorThemeGenerator, AppThemeStyle, Typography
│   └── widgets/            # CustomProfileBar, BodyFrameWidget, CustomButtonWidget
├── model/
│   ├── attendance/         # AttendanceEvent, AttendanceRecord, AttendanceSyncStatus
│   ├── employee/           # EmployeeModel, OfficeModel
│   └── leave/              # LeaveBalanceModel, LeaveRequestModel
├── controller/
│   ├── provider/           # AttendanceProvider, LeaveProvider, DashboardProvider, ThemeProvider
│   └── service/            # AttendanceService, LeaveService, EmployeeService (DioClient)
└── view/
    ├── dashboard/          # DashboardScreen (Profile Bar, Attendance Card, Leave Card, Recent History)
    ├── leave/              # LeaveScreen & LeaveApplyScreen
    └── settings/           # SettingsScreen (Profile, Theme, Mock Scenarios, Sync Banner) & ProfileScreen
```

### State Management: `Provider` + `ChangeNotifier`
- **DashboardProvider:** Coordinates employee profile summaries, leave count caching, and tab changes.
- **AttendanceProvider:** Manages check-in/out states, live stopwatch timer, geofence verification, and pending sync counter.
- **LeaveProvider:** Handles form validation, date calculations, overlap detection, and submission state.
- **ThemeProvider:** Handles Light Mode, Dark Mode, and System Default themes.

---

## 2. Section 3: Offline Storage & Synchronization

Offline synchronization is the core engineering challenge of this application:

```
[ User Action: Check In / Out ]
              │
              ▼
    [ Geofence Validation (<= 200m) ]
              │ Passed
              ▼
    [ Create AttendanceEvent ]
    ├── Unique Idempotency Key (evt_<ts>_<micro>)
    ├── Action: check_in / check_out
    ├── Timestamp & Coordinates
    └── Initial Status: Pending Sync
              │
              ▼
    [ Local Storage: FIFO Queue ]  ◄── Persists across app close/restart
              │
     ┌────────┴────────┐
     │                 │
 [ Online? ]       [ Offline ]
     │                 │
     ▼                 ▼
 [ POST API ]      [ Kept in Queue ]
     │                 ▲
     ├─────────────────┤  (Triggered via Connectivity Monitor
     │                 │   or manual "Sync Now")
     ▼
 [ Status: Synced / Rejected ]
```

### Approach to Event Identity & Idempotency:
- **Event Identity:** Every attendance action is assigned a globally unique `idempotencyKey` formatted as `evt_<timestamp_milliseconds>_<microseconds>`.
- **Idempotency Guarantee:** When retrying after a network drop or timeout, the exact same `idempotencyKey` is transmitted in `POST /attendance/events`. The backend maintains a set of processed keys (`processedIdempotencyKeys`). If a request with an already-processed key arrives, the server acknowledges it with `200 OK` without creating duplicate records.

---

## 3. Why Production Server Must Repeat Device-Side Validations

While client-side validation delivers instantaneous user feedback, **the production server must independently repeat all validation checks**:

| Validation Check | Risk if Client-Only | Server Responsibility |
| :--- | :--- | :--- |
| **GPS Geofencing (<= 200m)** | Rooted devices or mock location apps can spoof GPS coordinates. | Server cross-references IP geolocation, Wi-Fi BSSID signals, or cryptographic Play Integrity / DeviceCheck attestation. |
| **Attendance State & Duplicates** | Client clocks can be manipulated; multiple devices can submit simultaneous requests. | Server enforces database constraints: `UNIQUE(employee_id, date, session_type)` and idempotency key checks. |
| **Leave Overlap & Balance** | Concurrent submissions from multiple devices/browsers can overdraw balance. | Server executes overlap checks and ledger updates inside an atomic database transaction with `SERIALIZABLE` isolation. |
| **Input Validation** | API callers can bypass mobile client code and send empty reasons or malicious payloads. | Server enforces strict sanitization, length validation, and encoding checks. |

---

## 4. Section 5: Local Mock HTTP API & Scenarios

The embedded local mock HTTP server runs on `http://127.0.0.1:8085` and implements all suggested endpoints:
- `GET /employee/me`: Employee profile & office coordinates
- `GET /attendance?month=YYYY-MM`: Attendance history & today's status
- `POST /attendance/events`: Check-in & check-out actions
- `GET /leave/balance`: Available Casual & Sick leave balances
- `GET /leave/requests`: Previous leave requests
- `POST /leave/requests`: Submit leave application

### Testing Edge-Case Scenarios:
Navigate to **Settings > Mock API Scenarios** to toggle:
1. **Successful Responses (200 OK):** Normal operation.
2. **Slow Responses (4s Latency):** Simulates high latency or slow network.
3. **Timeouts (35s Delay):** Simulates client-side request timeout handling.
4. **Server Errors (500 Error):** Simulates backend server failures.
5. **Duplicate Attendance Conflicts (409):** Simulates duplicate attendance rejection.
6. **Leave Validation Rejection (422):** Simulates policy refusal.
7. **Reset Mock Data:** Restores initial state.

---

## 5. Assumptions, Limitations & Time Spent

- **Assumptions:**
  - One attendance session per employee per calendar day (no overnight shifts).
  - All calendar days within a leave request date range count as leave days.
  - Base company timezone: `Asia/Kolkata`.
- **Limitations:**
  - Background execution while the app is terminated is outside the scope (per assignment instructions).
- **Time Spent:**
  - Architecture & Project Cleanup: 1.5 hours
  - Offline Sync & Local Storage (FIFO, Idempotency): 2.5 hours
  - Geofencing & Location Simulation: 1 hour
  - Leave Validation & Management: 1.5 hours
  - Local Mock HTTP Server & Scenario Controller: 1.5 hours
  - **Total:** ~8 hours
