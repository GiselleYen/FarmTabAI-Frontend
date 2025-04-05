import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/farm_site.dart';
import '../providers/auth_provider.dart';
import '../services/farmSite_service.dart';
import '../services/user_service.dart';
import 'home_page_section/home_bar_chart.dart';
import 'home_page_section/home_environment_status.dart';
import 'home_page_section/home_farm_filter_header.dart';
import 'home_page_section/home_header.dart';
import 'home_page_section/home_recently_viewed.dart';
import 'home_page_section/home_shelf_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? profileImageUrl;
  String username = "User";
  bool isLoading = true;
  bool hasOrganization = true;
  int organizationID = 0;
  int userID = 0;

  int unreadNotifications = 0;
  int touchedIndex = -1;
  Farm? selectedFarm;
  Map<String, dynamic> averageData = {};
  bool isLoadingAverageData = false;
  MeasurementType _currentMeasurementType = MeasurementType.ph;

  @override
  void initState() {
    super.initState();
    fetchUserProfile().then((_) {
      loadSavedSettings();
    });
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = await authProvider.getUserProfile(context);
      setState(() {
        username = userData['username'] ?? "User";
        profileImageUrl = userData['profile_image_url'];
        hasOrganization = userData['organization_id'] != null;
        organizationID = userData['organization_id'];
        userID = userData['user_id'];
      });
      final userService = UserService();
      int count =
          await userService.getUnreadNotificationCount(userID, organizationID);
      setState(() => unreadNotifications = count);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFarmId = prefs.getInt('selected_farm_id');
    if (savedFarmId != null) {
      try {
        final farm = await FarmService().getFarmById(savedFarmId);
        setState(() {
          selectedFarm = farm;
          isLoadingAverageData = true;
        });
        final data = await FarmService().getAverageDailyConditions(farm.id!);
        setState(() {
          averageData = data;
          isLoadingAverageData = false;
        });
      } catch (e) {
        print("Failed to load saved farm: $e");
      }
    }
    final savedTypeStr = prefs.getString('measurement_type');
    if (savedTypeStr != null) {
      final type = MeasurementType.values.firstWhere(
        (e) => e.toString() == savedTypeStr,
        orElse: () => MeasurementType.ph,
      );
      setState(() => _currentMeasurementType = type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.primaryColor1.withOpacity(0.8),
                      TColor.primaryColor2.withOpacity(0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primaryColor1.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: HomeHeader(
                      userID: userID,
                      username: username,
                      profileImageUrl: profileImageUrl,
                      organizationID: organizationID,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeShelfCarousel()
                            .animate()
                            .fadeIn(duration: 300.ms),
                        SizedBox(height: 16),
                        HomeFarmFilterHeader(
                          selectedFarm: selectedFarm ??
                              Farm(
                                id: 0,
                                title: 'Loading...',
                                description: '',
                                imageUrl: '',
                                createdAt: DateTime.now(),
                              ),
                          onFarmSelected: (Farm farm) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('selected_farm_id', farm.id!);
                            setState(() {
                              selectedFarm = farm;
                              averageData = {};
                              isLoadingAverageData = true;
                            });
                            try {
                              final data = await FarmService()
                                  .getAverageDailyConditions(farm.id!);
                              setState(() => averageData = data);
                            } catch (e) {
                              print("Failed to fetch average data: $e");
                            } finally {
                              setState(() => isLoadingAverageData = false);
                            }
                          },
                        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                        SizedBox(height: 16),
                        HomeBarChart(
                          selectedFarm: selectedFarm,
                          touchedIndex: touchedIndex,
                          onBarTouched: (index) =>
                              setState(() => touchedIndex = index),
                          measurementType: _currentMeasurementType,
                          onMeasurementChanged:
                              (MeasurementType newType) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'measurement_type', newType.toString());
                            setState(() => _currentMeasurementType = newType);
                          },
                          averageData: averageData,
                          isLoading: isLoadingAverageData,
                        ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                        SizedBox(height: 20),
                        const HomeEnvironmentStatus()
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 300.ms),
                        SizedBox(height: 20),
                        HomeRecentlyViewed(userId: userID)
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 400.ms),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
