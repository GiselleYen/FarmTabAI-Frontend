import 'package:farmtab_ai_frontend/login_register/welcome_screen.dart';
import 'package:farmtab_ai_frontend/nav%20tab/shelf_tab_view.dart';
import 'package:farmtab_ai_frontend/widget/round_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../widget/shelf_carousel.dart';
import '../widget/shelf_row.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<int> showingTooltipOnSpots = [21];
  List<FlSpot> get allSpots => const [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40)
  ];

  int unreadNotifications = 3;
  int touchedIndex = -1;
  String selectedFarm = 'Farm A';
  List lastShelfArr = [
    {
      "name": "Shelf A",
      "image": "assets/images/shelfA.jpg",
      "pH": "7.5",
      "EC": "200",
      "progress": 0.3
    },
    {
      "name": "Shelf B",
      "image": "assets/images/shelfB.jpg",
      "pH": "6.5",
      "EC": "300",
      "progress": 0.4
    },
    {
      "name": "Shelf C",
      "image": "assets/images/shelfC.jpg",
      "pH": "8.5",
      "EC": "400",
      "progress": 0.7
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: TColor.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi Abby,",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          "10 November 2024",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 20,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NotificationView(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications_none_sharp,
                                size: 28,
                                color: TColor.primaryColor1,
                              ),
                            ),

                            // Show badge only if there are unread notifications
                            if (unreadNotifications > 0)
                              Positioned(
                                right: 5, // Position on the top-right corner
                                top: 5,
                                child: Container(
                                  padding: EdgeInsets.all(5), // Adjust padding for better fit
                                  decoration: BoxDecoration(
                                    color: Colors.red, // Badge background color
                                    shape: BoxShape.circle, // Circular shape
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 8, // Minimum size of the badge
                                    minHeight: 8,
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadNotifications.toString(), // Display unread count
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 12, // Adjust text size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'profile') {
                                    // Navigate to Profile Screen
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with your Profile screen widget
                                    // );
                                  } else if (value == 'logout') {
                                    // Handle Log Out action
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          "Log Out",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter',),
                                        ),
                                        content: Text(
                                          "Are you sure you want to log out?",
                                          style: TextStyle(fontFamily: 'Inter',),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context), // Close dialog
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close dialog
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => WelcomeScreen(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                                "Log Out",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                color: TColor.primaryColor1, // Cancel button color
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder( // Custom border for menu
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white, // Background color of menu
                                elevation: 8, // Shadow effect
                                constraints: BoxConstraints(
                                  minWidth: 100, // Set the width of the dropdown menu
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'profile',
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_circle, color: TColor.primaryColor1),
                                        SizedBox(width: 10),
                                        Text(
                                          "Profile Info",
                                          style: TextStyle(color: TColor.primaryColor1, fontSize: 14, fontFamily: 'Poppins',),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'logout',
                                    child: Row(
                                      children: [
                                        Icon(Icons.exit_to_app, color: TColor.primaryColor1),
                                        SizedBox(width: 10),
                                        Text(
                                          "Log Out",
                                          style: TextStyle(color: TColor.primaryColor1, fontSize: 14, fontFamily: 'Poppins',),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                child: CircleAvatar(
                                  radius: 26, // Adjust size
                                  backgroundImage: AssetImage("assets/images/profile_photo.jpg"), // Replace with your asset path
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: ShelfCarousel(),
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                // Container(
                //   padding:
                //   const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                //   decoration: BoxDecoration(
                //     color: TColor.primaryColor2.withOpacity(0.3),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         // track the harvest time
                //         "Your plants already growed 30 days !",
                //         style: TextStyle(
                //             color: TColor.black,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w700),
                //       ),
                //       SizedBox(
                //         width: 80,
                //         height: 25,
                //         child: RoundButton(
                //           title: "Harvest",
                //           type: RoundButtonType.bgGradient,
                //           fontSize: 12,
                //           fontWeight: FontWeight.w400,
                //           onPressed: () {
                //             // Navigator.push(
                //             //   context,
                //             //   MaterialPageRoute(
                //             //     builder: (context) =>
                //             //     const ActivityTrackerView(),
                //             //   ),
                //             // );
                //           },
                //         ),
                //       )
                //     ],
                //   ),
                // ),,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Average Health",
                      style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: TColor.primaryColor1,
                      ),
                      onPressed: () {

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Colors.white, // Customize background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // Rounded corners
                                  ),
                                  title: Text(
                                    'Select Farm',
                                    style: TextStyle(
                                      color: TColor.primaryColor1,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  content: Container(
                                    width: double.minPositive, // Constrains dialog width
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioListTile<String>(
                                          title: Text(
                                              'Farm A',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                          value: 'Farm A',
                                          groupValue: selectedFarm,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedFarm = value!;
                                            });
                                          },
                                          activeColor: TColor.primaryColor1, // Radio button color when selected
                                        ),
                                        RadioListTile<String>(
                                          title: Text(
                                            'Farm B',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                          value: 'Farm B',
                                          groupValue: selectedFarm,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedFarm = value!;
                                            });
                                          },
                                          activeColor: TColor.primaryColor1,
                                        ),
                                        RadioListTile<String>(
                                          title: Text(
                                            'Farm C',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                          value: 'Farm C',
                                          groupValue: selectedFarm,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedFarm = value!;
                                            });
                                          },
                                          activeColor: TColor.primaryColor1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontFamily: 'Inter',
                                          color: Colors.grey,),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold, color: TColor.primaryColor1),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, selectedFarm);
                                      },
                                    ),
                                  ],
                                  actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for buttons
                                  contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0), // Custom padding for content
                                  insetPadding: EdgeInsets.symmetric(horizontal: 40), // Dialog margin from screen edges
                                );
                              },
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            // Handle the selected farm here
                            print('Selected farm: $value');
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                Container(
                  height: media.width * 0.6,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align items at the top
                    children: [
                      // Farm Title (Centered)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1), // Add spacing
                        child: Center(
                          child: Text(
                            selectedFarm ?? 'Farm A',
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Adds spacing between title and chart

                      // Bar Chart
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                                tooltipMargin: 10,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  String weekDay;
                                  switch (group.x) {
                                    case 0:
                                      weekDay = 'Monday';
                                      break;
                                    case 1:
                                      weekDay = 'Tuesday';
                                      break;
                                    case 2:
                                      weekDay = 'Wednesday';
                                      break;
                                    case 3:
                                      weekDay = 'Thursday';
                                      break;
                                    case 4:
                                      weekDay = 'Friday';
                                      break;
                                    case 5:
                                      weekDay = 'Saturday';
                                      break;
                                    case 6:
                                      weekDay = 'Sunday';
                                      break;
                                    default:
                                      throw Error();
                                  }
                                  return BarTooltipItem(
                                    '$weekDay\n',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (rod.toY - 1).toString(),
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              touchCallback: (FlTouchEvent event, barTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      barTouchResponse == null ||
                                      barTouchResponse.spot == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex =
                                      barTouchResponse.spot!.touchedBarGroupIndex;
                                });
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: getTitles,
                                  reservedSize: 38,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: showingGroups(),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Environment Status",
                  style: TextStyle(
                    color: TColor.primaryColor1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.48,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 18,
                          ),
                          child: Row(  // Added Row to place icon and texts side by side
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.orange, Colors.redAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.thermostat,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 10),  // Added spacing between icon and texts
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Temperature",
                                    style: TextStyle(
                                      color: TColor.primaryColor1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    "27°C",
                                    style: TextStyle(
                                      color: TColor.primaryColor1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            showingTooltipIndicators:
                            showingTooltipOnSpots.map((index) {
                              return ShowingTooltipIndicators([
                                LineBarSpot(
                                  tooltipsOnBar,
                                  lineBarsData.indexOf(tooltipsOnBar),
                                  tooltipsOnBar.spots[index],
                                ),
                              ]);
                            }).toList(),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return;
                                }
                                if (event is FlTapUpEvent) {
                                  final spotIndex =
                                      response.lineBarSpots!.first.spotIndex;
                                  showingTooltipOnSpots.clear();
                                  setState(() {
                                    showingTooltipOnSpots.add(spotIndex);
                                  });
                                }
                              },
                              mouseCursorResolver: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return SystemMouseCursors.basic;
                                }
                                return SystemMouseCursors.click;
                              },
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                  List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Colors.red,
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                            radius: 3,
                                            color: Colors.white,
                                            strokeWidth: 3,
                                            strokeColor: TColor.secondaryColor1,
                                          ),
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                //tooltipBgColor: TColor.secondaryColor1,
                                tooltipRoundedRadius: 20,
                                getTooltipItems:
                                    (List<LineBarSpot> lineBarsSpot) {
                                  return lineBarsSpot.map((lineBarSpot) {
                                    return LineTooltipItem(
                                      "${lineBarSpot.x.toInt()} mins ago",
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: lineBarsData,
                            minY: 0,
                            maxY: 130,
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recently Viewed",
                      style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.01),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastShelfArr.length,
                    itemBuilder: (context, index) {
                      var wObj = lastShelfArr[index] as Map? ?? {};
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ShelfTabView(),
                              ),
                            );
                          },
                          child: ShelfRow(wObj: wObj));
                    }),
                SizedBox(
                  height: media.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.primaryColor1.withOpacity(0.6),
      fontWeight: FontWeight.w500,
      fontSize: 12,
      fontFamily: "Inter",
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =  Text('Sun', style: style);
        break;
      case 1:
        text =  Text('Mon', style: style);
        break;
      case 2:
        text =  Text('Tue', style: style);
        break;
      case 3:
        text =  Text('Wed', style: style);
        break;
      case 4:
        text =  Text('Thu', style: style);
        break;
      case 5:
        text =  Text('Fri', style: style);
        break;
      case 6:
        text =  Text('Sat', style: style);
        break;
      default:
        text =  Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, TColor.primaryG , isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 10.5, TColor.secondaryG, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, TColor.primaryG , isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, TColor.secondaryG, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 15, TColor.primaryG , isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 5.5, TColor.secondaryG, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 8.5, TColor.primaryG , isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartGroupData makeGroupData(
      int x,
      double y,
      List<Color> barColor,
      {
        bool isTouched = false,

        double width = 22,
        List<int> showTooltips = const [],
      }) {

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(colors: barColor, begin: Alignment.topCenter, end: Alignment.bottomCenter ),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      //tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.primaryColor2.withOpacity(0.5),
      TColor.primaryColor1.withOpacity(0.5),
    ]),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 35),
      FlSpot(2, 70),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 25),
      FlSpot(6, 70),
      FlSpot(7, 35),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.secondaryColor2.withOpacity(0.5),
      TColor.secondaryColor1.withOpacity(0.5),
    ]),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
    ),
    spots: const [
      FlSpot(1, 80),
      FlSpot(2, 50),
      FlSpot(3, 90),
      FlSpot(4, 40),
      FlSpot(5, 80),
      FlSpot(6, 35),
      FlSpot(7, 60),
    ],
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }
}