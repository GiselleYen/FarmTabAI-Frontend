import 'package:farmtab_ai_frontend/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

import '../../models/shelf.dart';
import '../../nav tab/home_tab_view.dart';
import '../../nav tab/shelf_tab_view.dart';
import '../../services/pinned_shelf_service.dart';
import '../../services/shelf_service.dart';
import '../../theme/color_extension.dart';

class ShelfData {
  final String name;
  final String condition;
  final String description;
  final double pieChartValue;
  final Shelf shelf;

  ShelfData({
    required this.name,
    required this.condition,
    required this.description,
    required this.pieChartValue,
    required this.shelf,
  });
}

class HomeShelfCarousel extends StatefulWidget {
  const HomeShelfCarousel({Key? key}) : super(key: key);

  @override
  State<HomeShelfCarousel> createState() => _HomeShelfCarouselState();
}

String _monthName(int month) {
  const months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return months[month - 1];
}

class _HomeShelfCarouselState extends State<HomeShelfCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  final List<ShelfData> _shelves = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPinnedShelf();
  }

  void _loadPinnedShelf() async {
    try {
      final pinnedList = await PinnedShelfService().getPinnedShelves();

      for (var pinned in pinnedList) {
        try {
          final shelfId = pinned['shelf_id'];
          final shelf = await ShelfService().getShelfById(shelfId);

          final int passed = shelf.passedDays ?? 0;
          final int total = shelf.harvestDays;
          final double progress = (total > 0) ? (passed / total * 100).clamp(0, 100) : 0;

          final expectedHarvestDate = DateTime.now().add(Duration(days: total - passed));
          final harvestDateString = "${expectedHarvestDate.day} "
              "${_monthName(expectedHarvestDate.month)} ${expectedHarvestDate.year}";

          if (mounted) {
            setState(() {
              _shelves.add(ShelfData(
                name: shelf.name,
                condition: harvestDateString,
                description: shelf.subtitle,
                pieChartValue: progress,
                shelf: shelf,
              ));
            });
          }
        } catch (e) {
          debugPrint('⚠️ Error loading pinned shelf ID ${pinned['shelf_id']}: $e');
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (_shelves.isNotEmpty) {
          _startTimer();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('⚠️ Error loading pinned shelves: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (!mounted || _shelves.isEmpty) {
        timer.cancel();
        return;
      }

      if (_shelves.length <= 1) {
        return;
      }

      final nextPage = (_currentPage + 1) % _shelves.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  List<PieChartSectionData> showingSections(double value) {
    return [
      // Completed section
      PieChartSectionData(
        gradient: const LinearGradient(
          colors: [Colors.yellow, Colors.redAccent],
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
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ],
          ),
        ),
        badgePositionPercentageOffset: 0.5,
      ),
      // Remaining section
      PieChartSectionData(
        color: Colors.white.withOpacity(0.8),
        value: 100 - value,
        title: '',
        radius: 45,
        titlePositionPercentageOffset: 0.55,
      ),
    ];
  }

  Widget _buildEmptyState(Size media) {
    return Container(
      width: double.infinity,
      height: media.width * 0.55,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withOpacity(0.08),
            TColor.primaryColor2.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryColor2.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes_outlined,
            size: 48,
            color: TColor.primaryColor1.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            _isLoading ? "Loading shelves..." : "No tracking shelf found.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          if (!_isLoading)
            Text(
              "Please set it in your target shelf.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.primaryColor1.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(ShelfData shelfData, Size media) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(media.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Image.asset(
            "assets/images/bg_dots.png",
            height: media.width * 0.55,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),

          // Title at the top
          Positioned(
            top: 15,
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
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side - Info and button
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shelfData.condition,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Expected Harvest Date",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 120,
                        height: 35,
                        child: RoundButton(
                            title: "View More",
                            type: RoundButtonType.bgSGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShelfTabView(shelf: shelfData.shelf),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - Pie chart
                Expanded(
                  flex: 2,
                  child: Container(
                    height: media.width * 0.32,
                    padding: const EdgeInsets.only(left: 10),
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: 250,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 1,
                        centerSpaceRadius: 0,
                        pieTouchData: PieTouchData(),
                        sections: showingSections(shelfData.pieChartValue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    if (_isLoading) {
      return _buildEmptyState(media);
    }

    if (_shelves.isEmpty) {
      return _buildEmptyState(media);
    }

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
              return _buildCarouselItem(_shelves[index], media);
            },
          ),
        ),
        const SizedBox(height: 10),

        // Page indicators
        if (_shelves.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _shelves.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
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