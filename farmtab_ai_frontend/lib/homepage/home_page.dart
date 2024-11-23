import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:farmtab_ai_frontend/login_register/welcome_screen.dart';
import 'package:farmtab_ai_frontend/widget/round_button.dart';
import 'package:farmtab_ai_frontend/widget/workout_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'activity_tracker_view.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List lastWorkoutArr = [
    {
      "name": "Full Body Workout",
      "image": "assets/images/Workout1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3,
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/images/Workout2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4,
    },
    {
      "name": "Ab Workout",
      "image": "assets/images/Workout3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7
    },
  ];
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

  int touchedIndex = -1;

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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   elevation: 0,
      //   leadingWidth: 0,
      //   toolbarHeight: 45,
      //   title: Text(
      //     "FarmTab AI",
      //     style: TextStyle(
      //         color: TColor.primaryColor1, fontSize: 20, fontWeight: FontWeight.w700),
      //   ),
      // ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "10 November 2024",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
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
                            icon: Image.asset(
                              "assets/images/notification_active.png",
                              width: 24,
                              height: 24,
                              fit: BoxFit.fitHeight,
                            )
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
                              // CircleAvatar with profile image
                              const CircleAvatar(
                                radius: 22, // Adjust size
                                backgroundImage: AssetImage("assets/images/profile_photo.jpg"), // Replace with your asset path
                              ),
                              // Dropdown button positioned on top of the avatar
                              Positioned(
                                top: 10,
                                right: 20,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: "Profile",
                                        child: Row(
                                          children: [
                                            Icon(Icons.account_circle, color: TColor.primaryColor1), // Profile icon
                                            SizedBox(width: 8),
                                            Text(
                                              "Profile Info",
                                              style: TextStyle(color: TColor.primaryColor1, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Logout",
                                        child: Row(
                                          children: [
                                            Icon(Icons.exit_to_app, color: TColor.primaryColor1), // Logout icon
                                            SizedBox(width: 8),
                                            Text(
                                              "Log Out",
                                              style: TextStyle(color: TColor.primaryColor1, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                    if (value == "Profile") {
                                      // Navigate to Profile page
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => ProfilePage()),
                                      // );
                                    } else if (value == "Logout") {
                                      // Handle log out action here
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => WelcomeScreen(),
                                        ),
                                      );
                                    }
                                  },
                                    dropdownColor: Colors.white,
                                  ),
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
                  height: media.width * 0.55,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.025)),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset(
                      "assets/images/bg_dots.png",
                      height: media.width * 0.55,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today Plant Condition",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Your plant overall is good!",
                                style: TextStyle(
                                    color: TColor.white.withOpacity(0.8),
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              SizedBox(
                                  width: 120,
                                  height: 35,
                                  child: RoundButton(
                                      title: "View More",
                                      type: RoundButtonType.bgSGradient,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      onPressed: () {}))
                            ],
                          ),
                          AspectRatio(
                            aspectRatio: 0.90,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 250,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // track the harvest time
                        "Your plants already growed 30 days !",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 80,
                        height: 25,
                        child: RoundButton(
                          title: "Harvest",
                          type: RoundButtonType.bgGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //     const ActivityTrackerView(),
                            //   ),
                            // );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Activity Progress",
                      style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Container(
                    //     height: 30,
                    //     padding: const EdgeInsets.symmetric(horizontal: 8),
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(colors: TColor.primaryG),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: DropdownButtonHideUnderline(
                    //       child: DropdownButton(
                    //         items: ["Weekly", "Monthly"]
                    //             .map((name) => DropdownMenuItem(
                    //           value: name,
                    //           child: Text(
                    //             name,
                    //             style: TextStyle(
                    //                 color: TColor.gray, fontSize: 14),
                    //           ),
                    //         ))
                    //             .toList(),
                    //         onChanged: (value) {},
                    //         icon: Icon(Icons.expand_more, color: TColor.white),
                    //         hint: Text(
                    //           "Weekly",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(color: TColor.white, fontSize: 12),
                    //         ),
                    //       ),
                    //     )
                    // ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.5,
                  padding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 0),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ]),
                  child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            //tooltipBgColor: Colors.grey,
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
                          rightTitles:  AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles:  AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: getTitles,
                              reservedSize: 38,
                            ),
                          ),
                          leftTitles:  AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingGroups(),
                        gridData:  FlGridData(show: false),
                      )
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
                  ),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.4,
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
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Temperature",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                      colors: TColor.primaryG,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                      0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "27°C",
                                  style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
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
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: TColor.gray,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                // ListView.builder(
                //     padding: EdgeInsets.zero,
                //     physics: const NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: lastWorkoutArr.length,
                //     itemBuilder: (context, index) {
                //       var wObj = lastWorkoutArr[index] as Map? ?? {};
                //       return InkWell(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) =>
                //                 const FinishedWorkoutView(),
                //               ),
                //             );
                //           },
                //           child: WorkoutRow(wObj: wObj));
                //     }),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
          (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 90,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: const Text(
                  "90.1",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 10,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
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

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}