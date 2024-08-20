import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/providers/statics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  static const routeName = '/statistics';

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime selectedDate = DateTime.now();
  int? selectedMonth;
  int? selectedYear;
  List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  List years = [2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030];
  bool _isLoading = false;
  bool _isInit = true;
  bool _todaySelection = true;
  bool _monthSelection = false;
  bool _yearSelection = false;
  Future<void> fetchStatistics() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String dateToFetch;
      if (_todaySelection) {
        dateToFetch =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        print(dateToFetch);
        await Provider.of<StatisticsProvider>(context, listen: false)
            .getStatistics('DailyStatistics', dateToFetch);
      } else if (_monthSelection && selectedMonth != null) {
        int year = selectedYear ?? DateTime.now().year;
        // Format the date as 'YYYY-MM'
        dateToFetch =
            "$year-${(selectedMonth! + 1).toString().padLeft(2, '0')}";
        print(dateToFetch);
        await Provider.of<StatisticsProvider>(context, listen: false)
            .getStatistics('MonthlyStatistics', dateToFetch);
      } else if (_yearSelection && selectedYear != null) {
        dateToFetch = "$selectedYear";
        print(dateToFetch);
        await Provider.of<StatisticsProvider>(context, listen: false)
            .getStatistics('YearlyStatistics', dateToFetch);
      } else {
        DateTime now = DateTime.now();
        dateToFetch =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        await Provider.of<StatisticsProvider>(context, listen: false)
            .getStatistics('MonthlyStatistics', dateToFetch);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  void selectMonth(int index) {
    setState(() {
      selectedMonth = index;
      _todaySelection = false;
      _monthSelection = true;
      _yearSelection = false;
    });
    fetchStatistics();
  }

  void selectYear(int index) {
    setState(() {
      selectedYear = index;
      _todaySelection = false;
      _monthSelection = false;
      _yearSelection = true;
    });
    fetchStatistics();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      fetchStatistics();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loadedStatistics =
        Provider.of<StatisticsProvider>(context).statistics;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _todaySelection = true;
                        _monthSelection = false;
                        _yearSelection = false;
                      });
                    },
                    child: Text(
                      'Today',
                      style: TextStyle(
                        color: _todaySelection ? primary : Colors.grey,
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _todaySelection = false;
                        _monthSelection = true;
                        _yearSelection = false;
                      });
                    },
                    child: Text(
                      'Month',
                      style: TextStyle(
                        color: _monthSelection ? primary : Colors.grey,
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _todaySelection = false;
                        _monthSelection = false;
                        _yearSelection = true;
                      });
                    },
                    child: Text(
                      'Year',
                      style: TextStyle(
                        color: _yearSelection ? primary : Colors.grey,
                        fontFamily: 'CENSCBK',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_todaySelection)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DatePicker(
                  DateTime.now(),
                  initialSelectedDate: selectedDate,
                  height: 105,
                  monthTextStyle: TextStyle(
                    color: white,
                    fontFamily: 'IrishGrover',
                  ),
                  dayTextStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'IrishGrover',
                    fontSize: 18,
                  ),
                  dateTextStyle: TextStyle(
                    color: primary,
                    fontSize: 24,
                    fontFamily: 'IrishGrover',
                  ),
                  selectionColor: Color.fromRGBO(156, 100, 156, 0.4),
                  selectedTextColor: primary,
                  onDateChange: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    fetchStatistics();
                  },
                ),
              ),
            if (_monthSelection)
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  itemBuilder: (context, i) => TextButton(
                    onPressed: () => selectMonth(i),
                    child: Text(
                      months[i],
                      style: TextStyle(
                        color: selectedMonth == i ? primary : Colors.grey,
                        fontFamily: 'IrishGrover',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            if (_yearSelection)
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  itemBuilder: (context, i) => TextButton(
                    onPressed: () => selectYear(years[i]),
                    child: Text(
                      years[i].toString(),
                      style: TextStyle(
                        color: selectedYear == years[i] ? primary : Colors.grey,
                        fontFamily: 'IrishGrover',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContainer(
                      height: size.height * 0.34,
                      width: size.width * 0.45,
                      containerColor: Color.fromRGBO(156, 100, 156, 0.68),
                      title: 'Customers',
                      titleColor: primary,
                      containerIcon: Icon(
                        Icons.people,
                        color: white,
                      ),
                      value: loadedStatistics['customers']!,
                      image: 'assets/images/barchart.svg',
                      isLoading: _isLoading,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    _buildContainer(
                      height: size.height * 0.28,
                      width: size.width * 0.45,
                      containerColor: onPrimary,
                      title: 'Rating',
                      titleColor: white,
                      containerIcon: Icon(
                        Icons.star,
                        color: white,
                      ),
                      value: loadedStatistics['rating']!,
                      image: 'assets/images/sharp_line.svg',
                      isLoading: _isLoading,
                    )
                  ],
                ),
                Column(
                  children: [
                    _buildContainer(
                      height: size.height * 0.28,
                      width: size.width * 0.45,
                      containerColor: Color.fromRGBO(195, 215, 231, 1),
                      title: 'Services',
                      titleColor: onPrimary,
                      containerIcon: Icon(
                        Icons.auto_graph,
                        color: white,
                      ),
                      value: loadedStatistics['services']!,
                      image: 'assets/images/curve_line.svg',
                      isLoading: _isLoading,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    _buildContainer(
                      height: size.height * 0.34,
                      width: size.width * 0.45,
                      containerColor: secondary.withOpacity(0.6),
                      title: 'Revenue',
                      titleColor: primary,
                      containerIcon: Icon(
                        Icons.monetization_on,
                        color: white,
                      ),
                      value: '${loadedStatistics['revenue']} \$',
                      image: 'assets/images/bargraph_with_points.svg',
                      isLoading: _isLoading,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildContainer({
    required double height,
    required double width,
    required Color containerColor,
    required String title,
    required Color titleColor,
    required Icon containerIcon,
    required String value,
    required String image,
    required bool isLoading,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: white,
            offset: const Offset(
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
                backgroundColor: Color.fromRGBO(217, 217, 217, 0.4),
                child: containerIcon,
              ),
            ],
          ),
          isLoading
              ? CircularProgressIndicator()
              : Text(
                  value,
                  style: TextStyle(
                    color: white,
                    fontFamily: 'CENSCBK',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          SvgPicture.asset(image)
        ],
      ),
    );
  }
}
