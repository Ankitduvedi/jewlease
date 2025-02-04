import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/hive_local_storage/model/location_model.dart';
import 'package:jewlease/feature/home/right_side_drawer/controller/drawer_controller.dart';
import 'package:jewlease/feature/home/right_side_drawer/repository/drawer_repository.dart';

class DrawerScreen extends ConsumerWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerProvider);
    final drawerNotifier = ref.read(drawerProvider.notifier);

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SSPL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Session ID: 18900526',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
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
                    log('in consumer widget');
                    final locations = ref.watch(locationListProvider);
                    final selectedLocation =
                        ref.watch(selectedLocationProvider);
                    log('Selected Location: ${selectedLocation!.locationName}');

                    if (selectedLocation.locationName.isEmpty) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Location",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          CircularProgressIndicator(),
                        ],
                      );
                    }

                    return DropdownButton<Location>(
                      value: locations.firstWhere(
                        (loc) =>
                            loc.locationCode == selectedLocation.locationCode,
                        orElse: () => locations.first,
                      ), // ✅ Ensure valid selection
                      isExpanded: true,
                      items: locations.map((location) {
                        return DropdownMenuItem<Location>(
                          value: location,
                          child: Text(location.locationName),
                        );
                      }).toList(),
                      onTap: () {
                        ref
                            .read(locationListProvider.notifier)
                            .fetchLocations(); // ✅ Fetch new data when opened
                      },
                      onChanged: (newValue) {
                        if (newValue != null) {
                          log('Selected Location: $newValue');
                          ref
                              .read(selectedLocationProvider.notifier)
                              .setSelectedLocation(newValue);
                        }
                      },
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
                _buildDropdown(
                  label: 'Role',
                  value: drawerState.role,
                  items: ['SA (ADMIN)', 'User'],
                  onChanged: drawerNotifier.setRole,
                ),
                _buildDivider(),
                // Department Dropdown
                _buildDropdown(
                  label: 'Select Department',
                  value: drawerState.department,
                  items: ['METAL CONTROL REACT', 'Department B'],
                  onChanged: drawerNotifier.setDepartment,
                  suffix: const Text('*', style: TextStyle(color: Colors.red)),
                ),
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
                    ElevatedButton(
                      onPressed: drawerNotifier.updateSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
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
