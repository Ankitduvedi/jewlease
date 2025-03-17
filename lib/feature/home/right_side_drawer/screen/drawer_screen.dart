import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/auth/controller/auth_controller.dart';
import 'package:jewlease/feature/home/right_side_drawer/controller/drawer_controller.dart';

class DrawerScreen extends ConsumerWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerProvider);
    final drawerNotifier = ref.read(drawerProvider.notifier);

    final employee = ref.read(authProvider.notifier).state;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee!.employeeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Session ID: 18900526',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      '12 Jan 2025',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Company Dropdown
                _buildDropdown(
                  label: 'Company',
                  value: drawerState.company,
                  items: [
                    'PBS (Bhagirathi Marketing Pvt. Ltd)',
                    'Company B',
                  ],
                  onChanged: drawerNotifier.setCompany,
                ),
                _buildDivider(),
                // Location Dropdown
                Consumer(
                  builder: (context, ref, child) {
                    final employee = ref.watch(authProvider);
                    final selectedLocation =
                        ref.watch(selectedLocationDropdownProvider);
                    final selectedDepartment =
                        ref.watch(selectedDepartmentProvider);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Dropdown
                        DropdownButton<Location>(
                          value: selectedLocation,
                          hint: const Text("Select Location"),
                          isExpanded: true,
                          items: employee!.locations.map((location) {
                            return DropdownMenuItem<Location>(
                              value: location,
                              child: Text(location.locationName),
                            );
                          }).toList(),
                          onChanged: (location) {
                            ref
                                .read(selectedLocationDropdownProvider.notifier)
                                .state = location!;
                            log("selected location: ${location.locationName}");
                            ref
                                    .read(selectedDepartmentProvider.notifier)
                                    .state =
                                (location.departments.isNotEmpty
                                    ? location.departments.first
                                    : null)!;
                            drawerNotifier.setLocation(location.locationName);
                            drawerNotifier.setDepartment;
                            // Reset department
                          },
                        ),

                        const SizedBox(height: 16),

                        // Department Dropdown (Depends on selected Location)
                        DropdownButton<Departments>(
                          value: selectedDepartment,
                          hint: const Text("Select Department"),
                          isExpanded: true,
                          items: selectedLocation.departments.map((dept) {
                            log("department: ${dept.departmentName}");
                            return DropdownMenuItem<Departments>(
                              value: dept,
                              child: Text(dept.departmentName),
                            );
                          }).toList(),
                          // ignore: unnecessary_null_comparison
                          onChanged: selectedLocation != null
                              ? (dept) {
                                  log('selected department: ${dept!.departmentName}');
                                  ref
                                      .read(selectedDepartmentProvider.notifier)
                                      .state = dept!;
                                  drawerNotifier.setDepartment(
                                      dept.departmentName.toString());
                                }
                              : null,
                        ),
                      ],
                    );
                  },
                ),

                _buildDivider(),
                // Day Close Switch
                SwitchListTile(
                  value: drawerState.isDayClose,
                  onChanged: drawerNotifier.setDayClose,
                  title: const Text(
                    'Day Close',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                _buildDivider(),
                // Financial Year Dropdown
                _buildDropdown(
                  label: 'Financial Year',
                  value: drawerState.financialYear,
                  items: [
                    '24-25 (01-Apr-2024 - 31-Mar-2025)',
                    '23-24 (01-Apr-2023 - 31-Mar-2024)',
                  ],
                  onChanged: drawerNotifier.setFinancialYear,
                ),
                _buildDivider(),
                // Role Dropdown
                Text(
                  employee.employeeType,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                _buildDivider(),
                // Department Dropdown

                _buildDivider(),
                // Cash Counter Dropdown
                _buildDropdown(
                  label: 'Select Cash Counter',
                  value: drawerState.cashCounter,
                  items: ['Counter 1', 'Counter 2'],
                  onChanged: drawerNotifier.setCashCounter,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ElevatedButton(
                    //   onPressed: drawerNotifier.updateSession,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.redAccent,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: const Text('Close'),
                    // ),
                    drawerNotifier.hasChanges
                        ? ElevatedButton(
                            onPressed: drawerNotifier.updateSession,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Update Session'),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items
            .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(e.toString())))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffix: suffix,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 24,
      color: Colors.grey,
    );
  }
}
