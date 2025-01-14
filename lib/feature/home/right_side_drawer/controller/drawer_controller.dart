import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/drawer_state.dart';

class DrawerNotifier extends StateNotifier<Session> {
  late Session _initialSession;

  DrawerNotifier()
      : super(const Session(
          company: 'PBS (Bhagirathi Marketing Pvt. Ltd)',
          location: 'Head Office (HO)',
          isDayClose: false,
          financialYear: '24-25 (01-Apr-2024 - 31-Mar-2025)',
          role: 'SA (ADMIN)',
          department: 'METAL CONTROL REACT',
          cashCounter: 'Counter 1',
        )) {
    // Initialize the initial session state
    _initialSession = state;
  }

  // Check if there are changes compared to the initial state
  bool get hasChanges => state != _initialSession;

  // Methods to update fields in the state
  void setCompany(String? company) {
    state = state.copyWith(company: company);
  }

  void setLocation(String? location) {
    state = state.copyWith(location: location);
  }

  void setDayClose(bool isDayClose) {
    state = state.copyWith(isDayClose: isDayClose);
  }

  void setFinancialYear(String? financialYear) {
    state = state.copyWith(financialYear: financialYear);
  }

  void setRole(String? role) {
    state = state.copyWith(role: role);
  }

  void setDepartment(String? department) {
    state = state.copyWith(department: department);
  }

  void setCashCounter(String? cashCounter) {
    state = state.copyWith(cashCounter: cashCounter);
  }

  // Function to update the session
  void updateSession() {
    // Perform update logic (e.g., API call or local save)
    print('Session updated: $state');

    // Set the current state as the new initial state
    _initialSession = state;
  }

  // Function to reset the session to the initial state
  void closeSession() {
    state = _initialSession;
  }
}

// Riverpod provider for the DrawerNotifier
final drawerProvider = StateNotifierProvider<DrawerNotifier, Session>((ref) {
  return DrawerNotifier();
});
