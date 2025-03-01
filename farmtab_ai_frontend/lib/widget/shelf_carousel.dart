import 'package:farmtab_ai_frontend/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

import '../theme/color_extension.dart';

// Data model for shelf content
class ShelfData {
  final String name;
  final String condition;
  final String description;
  final double pieChartValue;
  final String route;

  ShelfData({
    required this.name,
    required this.condition,
    required this.description,
    required this.pieChartValue,
    required this.route,
  });
}

class ShelfCarousel extends StatefulWidget {
  const ShelfCarousel({Key? key}) : super(key: key);

  @override
  State<ShelfCarousel> createState() => _ShelfCarouselState();
}

class _ShelfCarouselState extends State<ShelfCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Define different content for each shelf as a final field
  final List<ShelfData> _shelves = [
    ShelfData(
      name: 'Shelf A',
      condition: 'Good Condition',
      description: 'Expected Harvest: \n25 March 2025',
      pieChartValue: 95.0,
      route: '/shelf-a-details',
    ),
    ShelfData(
      name: 'Shelf B',
      condition: 'Good Condition',
      description: 'Expected Harvest: \n20 March 2025',
      pieChartValue: 85.0,
      route: '/shelf-b-details',
    ),
    ShelfData(
      name: 'Shelf C',
      condition: 'Fair Condition',
      description: 'Expected Harvest: \n21 March 2025',
      pieChartValue: 75.0,
      route: '/shelf-c-details',
    ),
    ShelfData(
      name: 'Shelf D',
      condition: 'Good Condition',
      description: 'Expected Harvest: \n18 March 2025',
      pieChartValue: 65.0,
      route: '/shelf-d-details',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    bool forward = true;

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (forward) {
        if (_currentPage < _shelves.length - 1) {
          _currentPage++;
        } else {
          forward = false;
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          forward = true;
          _currentPage++;
        }
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  List<PieChartSectionData> showingSections(double value) {
    return List.generate(
      2,
          (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.redAccent],  // Lighter to darker blue
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              value: value,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.55,
              badgeWidget: Text(
                "${value.toStringAsFixed(1)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 100 - value,
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: media.width * 0.55,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _shelves.length,
            itemBuilder: (context, index) {
              final shelfData = _shelves[index];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryG),
                  borderRadius: BorderRadius.circular(media.width * 0.025),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/images/bg_dots.png",
                      height: media.width * 0.55,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Positioned(
                      top: 18,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          shelfData.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shelfData.condition,
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                shelfData.description,
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: media.width * 0.03),
                              SizedBox(
                                width: 120,
                                height: 35,
                                child: RoundButton(
                                  title: "View More",
                                  type: RoundButtonType.bgSGradient,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  onPressed: () {
                                    Navigator.pushNamed(context, shelfData.route);
                                  },
                                ),
                              ),
                            ],
                          ),
                          AspectRatio(
                            aspectRatio: 0.8,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 250,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(shelfData.pieChartValue).map((section) =>
                                    section.copyWith(
                                      borderSide: BorderSide(
                                        color: TColor.gray.withOpacity(0.2), // Shadow effect
                                        width: 1.0, // Thickness for better visibility
                                      ),
                                    )
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _shelves.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? TColor.primaryG[1]
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}