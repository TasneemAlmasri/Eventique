import '/color.dart';
import '/models/vendor_model.dart';
import '/providers/business_overview_provider.dart';
import '/widgets/yearly_revenue_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

import '../models/revenue_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _loadingsta = false;
  bool _loadingCom = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedYear = '2024';
  List<charts.Series<Revenue, String>> _chartData = [];
  bool _isInit = true;

  Future<void> fetchTotalStatistics() async {
    try {
      setState(() {
        _loadingsta = true;
      });
      await Provider.of<BusinessOverviewPro>(context, listen: false)
          .getTotalStatistics();

      setState(() {
        _loadingsta = false;
      });
    } catch (error) {
      setState(() {
        _loadingsta = false;
      });
      print(error);
    }
  }

  Future<void> fetchStatistics() async {
    try {
      setState(() {
        _loadingsta = true;
      });

      String dateToFetch;

      // Format the date as 'YYYY-MM-DD'
      dateToFetch =
          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
      print(dateToFetch);
      await Provider.of<BusinessOverviewPro>(context, listen: false)
          .getStatistics('DailyStatistics', dateToFetch);

      setState(() {
        _loadingsta = false;
      });
    } catch (error) {
      setState(() {
        _loadingsta = false;
      });
      print(error);
    }
  }

  Future<void> fetchDataForYear(String year) async {
    try {
      setState(() {
        _loadingsta = true;
      });
      var revenueData =
          await Provider.of<BusinessOverviewPro>(context, listen: false)
              .dataForYear(year);

      // Map the fetched data to _chartData
      List<Revenue> data = revenueData.entries.map((entry) {
        return Revenue(_monthName(int.parse(entry.key)), entry.value);
      }).toList();

      setState(() {
        _chartData = [
          charts.Series<Revenue, String>(
            id: 'Revenue',
            colorFn: (Revenue revenue, int? index) {
              if (index != null && index % 2 == 0) {
                return charts.Color.fromHex(code: '#570E57');
              } else {
                return charts.Color.fromHex(code: '#570E57').darker;
              }
            },
            domainFn: (Revenue revenue, _) => revenue.month,
            measureFn: (Revenue revenue, _) => revenue.revenue,
            data: data,
          )
        ];
        _loadingsta = false;
      });
    } catch (error) {
      setState(() {
        _loadingsta = false;
      });
      print(error);
    }
  }

  String _monthName(int monthNumber) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[monthNumber - 1];
  }

  Future<void> fetchCompanies() async {
    try {
      setState(() {
        _loadingCom = true;
      });
      await Provider.of<BusinessOverviewPro>(context, listen: false)
          .companiesRequests();

      setState(() {
        _loadingCom = false;
      });
    } catch (error) {
      setState(() {
        _loadingCom = false;
      });
      print(error);
    }
  }

  Future<void> updateCompanyStatus(int id, bool status) async {
    try {
      setState(() {
        _loadingCom = true;
      });
      await Provider.of<BusinessOverviewPro>(context, listen: false)
          .updateCompanyStatus(id, status);
      fetchCompanies();
      setState(() {
        _loadingCom = false;
      });
    } catch (error) {
      setState(() {
        _loadingCom = false;
      });
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      fetchDataForYear(_selectedYear);
      fetchTotalStatistics();
      fetchCompanies();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // Call async methods to fetch data
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchDataForYear(_selectedYear);
    await fetchTotalStatistics();
    await fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loadedStatistics =
        Provider.of<BusinessOverviewPro>(context, listen: false).statistics;
    final companies = Provider.of<BusinessOverviewPro>(context, listen: false)
        .getCompaniesRequests;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContainer(
                height: size.height * 0.2,
                width: size.width / 5.8,
                containerColor: const Color.fromRGBO(156, 100, 156, 0.68),
                title: 'Customers',
                titleColor: primary,
                containerIcon: Icons.people,
                value: loadedStatistics['customers']!,
                isLoading: _loadingsta,
              ),
              _buildContainer(
                height: size.height * 0.2,
                width: size.width / 5.8,
                containerColor: secondary.withOpacity(0.6),
                title: 'Companies',
                titleColor: primary,
                containerIcon: Icons.corporate_fare,
                value: loadedStatistics['companies']!,
                isLoading: _loadingsta,
              ),
              _buildContainer(
                height: size.height * 0.2,
                width: size.width / 5.8,
                containerColor: onPrimary,
                title: 'Revenue',
                titleColor: white,
                containerIcon: Icons.attach_money_rounded,
                value: '${loadedStatistics['revenue']} \$',
                isLoading: _loadingsta,
              ),
              _buildContainer(
                height: size.height * 0.2,
                width: size.width / 5.8,
                containerColor: const Color.fromRGBO(195, 215, 231, 1),
                title: 'Events',
                titleColor: onPrimary,
                containerIcon: Icons.event_available,
                value: loadedStatistics['events']!,
                isLoading: _loadingsta,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: size.height / 3,
                width: 780,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.5),
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: size.height / 2.9,
                  width: 750,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Yearly Revenue',
                              style: TextStyle(
                                color: primary,
                                fontFamily: 'CENSCBK',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: DropdownButton<String>(
                              value: _selectedYear,
                              items:
                                  ['2022', '2023', '2024'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedYear = newValue!;
                                  fetchDataForYear(_selectedYear);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: YearlyRevenueChart(
                          _chartData,
                          animate: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height / 3,
                width: size.width / 5.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.5),
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: size.height / 3,
                  width: size.width / 5.8,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary:
                            primary.withOpacity(0.8), // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: onPrimary, // default text color
                      ),
                      datePickerTheme: const DatePickerThemeData(
                        yearStyle: TextStyle(
                          color: primary,
                          fontFamily: 'CENSCBK',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        weekdayStyle: TextStyle(
                          color: secondary,
                          fontFamily: 'CENSCBK',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStyle: TextStyle(
                          color: primary,
                          fontFamily: 'CENSCBK',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2030),
                      onDateChanged: (newDate) {
                        setState(
                          () {
                            _selectedDate = newDate;
                          },
                        );
                        fetchStatistics();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: size.height / 3,
            width: size.width * 0.77,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.5),
                  offset: const Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: _loadingCom
                ? const Center(child: CircularProgressIndicator(color: primary))
                : companies.isEmpty
                    ? Center(
                        child: Text(
                          'No companies requests yet',
                          style: TextStyle(
                            color: primary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: companies.length,
                        itemBuilder: (context, index) {
                          final request = companies[index];
                          return InkWell(
                            onTap: () {
                              _showDetailsDialog(request, context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(request.logoUrl),
                                  ),

                                  Text(
                                    request.companyName,
                                    style: TextStyle(
                                      color: primary,
                                      fontFamily: 'CENSCBK',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${request.email}',
                                    style: TextStyle(
                                      color: primary,
                                      fontFamily: 'CENSCBK',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '0${request.phoneNumber}',
                                    style: TextStyle(
                                      color: primary,
                                      fontFamily: 'CENSCBK',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Action Buttons
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: secondary,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          updateCompanyStatus(request.id, true);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: primary,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          updateCompanyStatus(
                                              request.id, false);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(Vendor request, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            request.companyName,
            style: TextStyle(
              color: primary,
              fontFamily: 'CENSCBK',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      request.logoUrl,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.firstName} ${request.lastName}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Email: ',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${request.email}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Phone:',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.phoneNumber}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Registration Number:',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.registrationNumber}',
                      style: TextStyle(
                        color: onPrimary,
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
                        Text(
                          'Location:',
                          style: TextStyle(
                            color: secondary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.location}',
                          style: TextStyle(
                            color: onPrimary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'City:',
                          style: TextStyle(
                            color: secondary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.city}',
                          style: TextStyle(
                            color: onPrimary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Country:',
                          style: TextStyle(
                            color: secondary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${request.country}',
                          style: TextStyle(
                            color: onPrimary,
                            fontFamily: 'CENSCBK',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Description:',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.description}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Categories:',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.categoryIds.join(', ')}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Event Types:',
                      style: TextStyle(
                        color: secondary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${request.eventTypeIds.join(', ')}',
                      style: TextStyle(
                        color: onPrimary,
                        fontFamily: 'CENSCBK',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Work Hours:',
                  style: TextStyle(
                    color: secondary,
                    fontFamily: 'CENSCBK',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: request.workHours
                      .map((dayMap) {
                        return dayMap.entries.map((entry) {
                          return Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(
                              color: onPrimary,
                              fontFamily: 'CENSCBK',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      })
                      .expand((element) => element)
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateCompanyStatus(request.id, false);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: secondary,
                  fontFamily: 'CENSCBK',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                updateCompanyStatus(request.id, true);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Reject',
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: primary,
                  fontFamily: 'CENSCBK',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Container _buildContainer({
  required double height,
  required double width,
  required Color containerColor,
  required String title,
  required Color titleColor,
  required IconData containerIcon,
  required String value,
  required bool isLoading,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: containerColor,
      boxShadow: [
        const BoxShadow(
          color: white,
          offset: Offset(
            1.0,
            1.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontFamily: 'IrishGrover',
                fontSize: 18,
              ),
            ),
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(217, 217, 217, 0.4),
              child: Icon(
                containerIcon,
                color: white,
              ),
            ),
          ],
        ),
        isLoading
            ? const CircularProgressIndicator()
            : Text(
                value,
                style: const TextStyle(
                  color: white,
                  fontFamily: 'CENSCBK',
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    ),
  );
}
