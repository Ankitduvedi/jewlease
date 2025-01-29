class Session {
  final String company;
  final String location;
  final bool isDayClose;
  final String financialYear;
  final String role;
  final String department;
  final String cashCounter;

  const Session({
    required this.company,
    required this.location,
    required this.isDayClose,
    required this.financialYear,
    required this.role,
    required this.department,
    required this.cashCounter,
  });

  Session copyWith({
    String? company,
    String? location,
    bool? isDayClose,
    String? financialYear,
    String? role,
    String? department,
    String? cashCounter,
  }) {
    return Session(
      company: company ?? this.company,
      location: location ?? this.location,
      isDayClose: isDayClose ?? this.isDayClose,
      financialYear: financialYear ?? this.financialYear,
      role: role ?? this.role,
      department: department ?? this.department,
      cashCounter: cashCounter ?? this.cashCounter,
    );
  }

  bool isEqual(Session other) {
    return company == other.company &&
        location == other.location &&
        isDayClose == other.isDayClose &&
        financialYear == other.financialYear &&
        role == other.role &&
        department == other.department &&
        cashCounter == other.cashCounter;
  }
}
