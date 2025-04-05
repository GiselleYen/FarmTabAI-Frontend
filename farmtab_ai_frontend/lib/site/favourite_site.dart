import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../models/shelf.dart';
import '../nav tab/shelf_tab_view.dart';
import '../services/shelf_service.dart';
import '../widget/card_small.dart';

class FavoriteShelfPage extends StatefulWidget {
  const FavoriteShelfPage({super.key});

  @override
  State<FavoriteShelfPage> createState() => _FavoriteShelfPageState();
}

class _FavoriteShelfPageState extends State<FavoriteShelfPage> {
  List<Shelf> _favoriteShelves = [];
  final ShelfService _shelfService = ShelfService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final shelves = await _shelfService.getFavoriteShelves();
      setState(() {
        _favoriteShelves = shelves;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primaryColor1, TColor.primaryColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Favorite Shelves",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26, // Slightly larger
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.5, // Add slight letter spacing
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.sort, color: Colors.white, size: 24),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => _buildSortOptions(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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
                  ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1)))
                  : _favoriteShelves.isEmpty
                  ? _buildEmptyState()
                  : _buildFavoriteGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100, // Larger icon container
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.primaryG, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: TColor.primaryColor1.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.favorite_border, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          'No Favorite Shelves Yet',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Items you favorite will appear here for quick access',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontFamily: "Inter",
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slide(begin: Offset(0, 0.1), duration: 500.ms);
  }

  Widget _buildFavoriteGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16, left: 8),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 24,
                decoration: BoxDecoration(
                  color: TColor.primaryColor1,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [BoxShadow(color: TColor.primaryColor1.withOpacity(0.3), blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Your Favorites",
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        RefreshIndicator(
          color: TColor.primaryColor1,
          backgroundColor: Colors.white,
          strokeWidth: 2.5, // Slightly thicker refresh indicator
          onRefresh: _loadFavorites,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 140 / 190, // Slightly taller cards
              crossAxisSpacing: 18,
              mainAxisSpacing: 20,
            ),
            itemCount: _favoriteShelves.length,
            itemBuilder: (context, index) {
              final shelf = _favoriteShelves[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 15,
                      offset: Offset(0, 7),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CardSmall(
                  title: shelf.name,
                  subtitle: shelf.subtitle,
                  image: shelf.shelfImageUrl.startsWith('http') ? shelf.shelfImageUrl : 'assets/images/placeholder.jpg',
                  isFavorite: shelf.isFavourite,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShelfTabView(shelf: shelf)));
                  },
                ),
              ).animate().fadeIn(duration: 350.ms, delay: (index * 120).ms).scale(duration: 400.ms);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: Offset(0, -5))],
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(2.5)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
              children: [
                Icon(Icons.sort, color: TColor.primaryColor1, size: 24),
                SizedBox(width: 10),
                Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryColor1,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildSortOption(Icons.sort_by_alpha, 'Name', () {
            setState(() {
              _favoriteShelves.sort((a, b) => a.name.compareTo(b.name));
            });
            Navigator.pop(context);
          }),
          _buildSortOption(Icons.access_time, 'Date Added', () {
            setState(() {
              _favoriteShelves.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
            });
            Navigator.pop(context);
          }),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSortOption(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.primaryColor1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: TColor.primaryColor1, size: 20),
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}