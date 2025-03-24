import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login_register/welcome_screen.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../theme/color_extension.dart';
import '../services/organization_service.dart';
import '../services/user_service.dart';
import 'tabs/organizations_tab.dart';
import 'tabs/users_tab.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> users = [];
  List<Organization> organizations = [];
  String? _selectedFilter;
  bool _isLoading = true;

  late OrganizationService _organizationService;
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _organizationService = OrganizationService();
    _userService = UserService();

    // Fetch data when the page loads
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orgList = await _organizationService.getOrganizations();
      final userList = await _userService.getUsers();

      setState(() {
        organizations = orgList;
        users = userList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _assignUserToOrganization(User user, String? organizationId) async {
    try {
      final updatedUser = await _userService.assignUserToOrganization(user.id, organizationId);

      setState(() {
        final userIndex = users.indexWhere((u) => u.id == user.id);
        if (userIndex != -1) {
          users[userIndex] = updatedUser;
        }
      });

      String message;
      if (organizationId == null) {
        message = 'Removed ${user.name} from organization';
      } else {
        final org = organizations.firstWhere((org) => org.id == organizationId);
        message = 'Assigned ${user.name} to ${org.name}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TColor.primaryColor1,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error assigning organization: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleUserRole(User user) async {
    try {
      final newRole = user.role == 'user' ? 'manager' : 'user';
      final updatedUser = await _userService.updateUserRole(user.id, newRole);

      setState(() {
        final userIndex = users.indexWhere((u) => u.id == user.id);
        if (userIndex != -1) {
          users[userIndex] = updatedUser;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Changed ${user.name} role to ${updatedUser.role}'),
          backgroundColor: TColor.primaryColor1,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating role: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addOrganization() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Organization'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Organization Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: TColor.primaryColor1),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();

                try {
                  final newOrg = Organization(
                    id: '', // ID will be assigned by server
                    name: nameController.text.trim(),
                  );

                  final createdOrg = await _organizationService.createOrganization(newOrg);

                  setState(() {
                    organizations.add(createdOrg);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added organization: ${createdOrg.name}'),
                      backgroundColor: TColor.primaryColor1,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add organization: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryColor1,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  List<User> get filteredUsers {
    if (_selectedFilter == null) {
      return users;
    } else if (_selectedFilter == 'unassigned') {
      return users.where((user) => user.organizationId == null).toList();
    } else if (_selectedFilter == 'managers') {
      return users.where((user) => user.role == 'manager').toList();
    } else {
      return users.where((user) => user.organizationId == _selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColor.primaryColor1,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Organizations'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: _fetchData,
            child: UsersTab(
              users: users,
              organizations: organizations,
              filteredUsers: filteredUsers,
              selectedFilter: _selectedFilter,
              onFilterChanged: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
              onAssignOrganization: _assignUserToOrganization,
              onToggleRole: _toggleUserRole,
            ),
          ),
          RefreshIndicator(
            onRefresh: _fetchData,
            child: OrganizationsTab(
              organizations: organizations,
              users: users,
              onUpdateOrganization: (index, name) async {
                final updatedOrg = await _organizationService.updateOrganization(
                  organizations[index].id,
                  Organization(
                    id: organizations[index].id,
                    name: name,
                  ),
                );

                setState(() {
                  organizations[index] = updatedOrg;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            // Add user functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add user functionality would go here'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Add organization
            _addOrganization();
          }
        },
        backgroundColor: TColor.primaryColor1,
        child: const Icon(Icons.add),
      ),
    );
  }
}