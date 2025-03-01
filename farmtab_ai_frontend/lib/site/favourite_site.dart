import 'package:flutter/material.dart';
import "package:farmtab_ai_frontend/widget/card_small.dart";

import '../theme/color_extension.dart';
import '../widget/card_small.dart';

class FavoriteShelfPage extends StatefulWidget {
  const FavoriteShelfPage({super.key});

  @override
  State<FavoriteShelfPage> createState() => _FavoriteShelfPageState();
}

class _FavoriteShelfPageState extends State<FavoriteShelfPage> {
  // In a real app, this would come from your backend/state management
  final List<Map<String, dynamic>> _favoriteItems = [
    {
      'id': '1',
      'title': 'Shelf A1',
      'subtitle': 'Temperature: 23°C',
      'image': 'assets/images/shelfA.jpg',
      'isFavorite': true,
    },
    {
      'id': '2',
      'title': 'Shelf B2',
      'subtitle': 'Temperature: 22°C',
      'image': 'assets/images/shelfB.jpg',
      'isFavorite': true,
    },
    // Add more items as needed
  ];

  void _removeFavorite(String itemId) {
    setState(() {
      _favoriteItems.removeWhere((item) => item['id'] == itemId);
    });
    // In a real app, you'd also update your backend/state management
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Favorite Shelves',
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.sort,
              color: TColor.primaryColor1,
            ),
            onPressed: () {
              // Implement sorting functionality
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildSortOptions(),
              );
            },
          ),
        ],
      ),
      body: _favoriteItems.isEmpty
          ? _buildEmptyState()
          : _buildFavoriteGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite shelves yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Items you favorite will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteGrid() {
    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh functionality
        // In a real app, you'd fetch updated data from your backend
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 140 / 180, // Match CardSmall dimensions
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _favoriteItems.length,
        itemBuilder: (context, index) {
          final item = _favoriteItems[index];
          return CardSmall(
            title: item['title'],
            subtitle: item['subtitle'],
            image: item['image'],
            isFavorite: item['isFavorite'],
            onTap: () {
              // Navigate to shelf detail page
              // Navigator.push(context, MaterialPageRoute(...));
            },
          );
        },
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            title: Text('Sort by',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColor.primaryColor1,
                fontFamily: "Poppins",
              ),
            ),
            style: ListTileStyle.drawer,
          ),
          ListTile(
            leading: Icon(Icons.sort_by_alpha, color: TColor.primaryColor1),
            title: Text('Name',
              style: TextStyle(
                color: TColor.primaryColor1,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),),
            onTap: () {
              setState(() {
                _favoriteItems.sort((a, b) =>
                    a['title'].compareTo(b['title'])
                );
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: TColor.primaryColor1),
            title: Text('Date Added',
              style: TextStyle(
                color: TColor.primaryColor1,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),),
            onTap: () {
              // Implement date sorting
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}