class DrawerRepository {
  // Fetch data for dropdowns
  Future<List<String>> fetchCompanies() async {
    // Simulate API call
    return Future.value(['Company A', 'Company B']);
  }

  Future<List<String>> fetchLocations() async {
    return Future.value(['Location A', 'Location B']);
  }

  // Add other repository methods for fetching or updating data
}
