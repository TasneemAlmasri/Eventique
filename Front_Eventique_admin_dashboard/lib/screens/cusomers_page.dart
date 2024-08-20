import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventique_admin_dashboard/color.dart';
import 'package:eventique_admin_dashboard/models/customer/customer.dart';
import 'package:eventique_admin_dashboard/models/user/user.dart';
import 'package:eventique_admin_dashboard/providers/customer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CustomersPage extends StatefulWidget {
  final String token;

  const CustomersPage({super.key, required this.token});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isUsersLoading = false;
  bool _isCompaniesLoading = false;
  String _searchQuery = '';
  List<User> _filteredUsers = [];
  List<Company> _filteredCompanies = [];

  void _showDetailsDialog(Company request, BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    bool _isDeleting = false;

    Future<void> _deleteCompany() async {
      setState(() {
        _isDeleting = true;
      });

      try {
        await customerProvider
            .deleteCompany(request.id!); // Assuming you have this method
        Navigator.of(context).pop(); // Close the dialog on successful deletion
      } catch (e) {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete company')),
        );
      } finally {
        setState(() {
          _isDeleting = false;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            request.companyName,
            style: const TextStyle(
              fontFamily: 'CENSCBK',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary, // Set color to primary
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Name: ',
                      style: TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.firstName} ${request.lastName}',
                      style: const TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Email: ',
                      style: TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${request.email}',
                      style: const TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Phone:',
                      style: TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0${request.phoneNumber}',
                      style: const TextStyle(
                        color: primary, // Set color to primary
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Location:',
                          style: TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.loaction}',
                          style: const TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'City:',
                          style: TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.city}',
                          style: const TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Country:',
                          style: TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.country}',
                          style: const TextStyle(
                            color: primary, // Set color to primary
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if (_isDeleting)
              const Center(
                  child: CircularProgressIndicator()) // Show loading indicator
            else
              TextButton(
                onPressed: () {
                  _deleteCompany(); // Call delete function
                },
                child: const Text('Delete',
                    style: TextStyle(color: primary)), // Set color to primary
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isUsersLoading = true;
      _isCompaniesLoading = true;
    });

    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    await Future.wait([
      customerProvider.fetchUsers(widget.token),
      customerProvider.fetchCompanies(widget.token),
    ]);

    setState(() {
      _isUsersLoading = false;
      _isCompaniesLoading = false;
      _filteredUsers = customerProvider.users;
      _filteredCompanies = customerProvider.companies;
    });
  }

  void _filterSearchResults(String query) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    setState(() {
      _searchQuery = query;

      _filteredUsers = customerProvider.users
          .where((user) =>
              (user.name ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (user.email ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();

      _filteredCompanies = customerProvider.companies
          .where((company) =>
              (company.firstName ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (company.email ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _onTabChanged() async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    if (_tabController.index == 0) {
      setState(() {
        _isUsersLoading = true;
        _isCompaniesLoading = true;
      });

      await Future.wait([
        customerProvider.fetchUsers(widget.token),
        customerProvider.fetchCompanies(widget.token),
      ]);

      setState(() {
        _isUsersLoading = false;
        _isCompaniesLoading = false;
      });
    } else if (_tabController.index == 1) {
      setState(() {
        _isUsersLoading = true;
      });

      await customerProvider.fetchUsers(widget.token);

      setState(() {
        _isUsersLoading = false;
      });
    } else if (_tabController.index == 2) {
      setState(() {
        _isCompaniesLoading = true;
      });

      await customerProvider.fetchCompanies(widget.token);

      setState(() {
        _isCompaniesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 600.0,
                child: TextField(
                  onChanged: (value) {
                    _filterSearchResults(value);
                  },
                  decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'All',
                ),
                Tab(text: 'Users'),
                Tab(text: 'Company'),
              ],
              labelColor: primary,
              indicatorColor: primary,
              dividerColor: Colors.white,
              labelStyle: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                  fontFamily: 'CENSCBK',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _isUsersLoading || _isCompaniesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildUsersAndCompaniesList(
                          customerProvider.users, customerProvider.companies),
                  _isUsersLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildUserList(customerProvider.users),
                  _isCompaniesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildCompaniesList(customerProvider.companies),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCompaniesList(List<Company> companies) {
    if (_filteredCompanies.isEmpty) {
      return const Center(child: Text('No companies available'));
    }

    return ListView.builder(
      itemCount: _filteredCompanies.length,
      itemBuilder: (context, index) {
        final company = _filteredCompanies[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              _showDetailsDialog(company, context);
            },
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: company.images?.isNotEmpty == true
                        ? company.images!.first
                        : "https://via.placeholder.com/150",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) => Container(
                      color: const Color.fromARGB(255, 242, 242, 242),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color.fromARGB(255, 242, 242, 242),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.firstName ?? 'No Name',
                        style: const TextStyle(
                            fontFamily: 'CENSCBK',
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '0${company.phoneNumber}',
                        style: const TextStyle(
                            fontFamily: 'CENSCBK',
                            // fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildUserList(List<User> users) {
    if (_filteredUsers.isEmpty) {
      return const Center(child: Text('No users available'));
    }

    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.images?.isNotEmpty == true
                      ? user.images!.first
                      : "https://via.placeholder.com/150",
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) => Container(
                    color: const Color.fromARGB(255, 242, 242, 242),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color.fromARGB(255, 242, 242, 242),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'No Name',
                      style: const TextStyle(
                          fontFamily: 'CENSCBK',
                          fontWeight: FontWeight.bold,
                          color: primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? 'No Email',
                      style: const TextStyle(
                          fontFamily: 'CENSCBK',
                          // fontWeight: FontWeight.bold,
                          color: primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersAndCompaniesList(
      List<User> users, List<Company> companies) {
    return ListView(
      children: [
        ..._filteredUsers.map((user) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.images?.isNotEmpty == true
                          ? user.images!.first
                          : "https://via.placeholder.com/150",
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      placeholder: (context, url) => Container(
                        color: const Color.fromARGB(255, 242, 242, 242),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color.fromARGB(255, 242, 242, 242),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? 'No Name',
                          style: const TextStyle(
                              fontFamily: 'CENSCBK',
                              fontWeight: FontWeight.bold,
                              color: primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? 'No Email',
                          style: const TextStyle(
                              fontFamily: 'CENSCBK',
                              // fontWeight: FontWeight.bold,
                              color: primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ..._filteredCompanies.map((company) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  _showDetailsDialog(company, context);
                },
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: company.images?.isNotEmpty == true
                            ? company.images!.first
                            : "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        placeholder: (context, url) => Container(
                          color: const Color.fromARGB(255, 242, 242, 242),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color.fromARGB(255, 242, 242, 242),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.firstName ?? 'No Name',
                            style: const TextStyle(
                                fontFamily: 'CENSCBK',
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '0${company.phoneNumber}',
                            style: const TextStyle(
                                fontFamily: 'CENSCBK',
                                // fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
