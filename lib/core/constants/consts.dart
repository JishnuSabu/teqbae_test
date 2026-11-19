String currentDate = DateTime.now().toIso8601String().split('T').first;

List<String> listDatas = ["All", "Pending", "Approved", "Rejected"];
List<String> customerListDsta = ["Customer", "Bus stand", "Courier Point"];

class CustomerTabType {
  static const int customer = 0;
  static const int bustand = 1;
  static const int courier = 2;
}

/// Tabs that should show collection-only actions in check-in/check-out.
const Set<int> collectionOnlyCustomerTabs = <int>{
  CustomerTabType.bustand,
  CustomerTabType.courier,
};

List<String> listEod = ["Team Report", "My Report"];

List<String> listTask = ["Pending", "Completed"];
List<String> listAssignTask = ["Assign", "Completed"];
