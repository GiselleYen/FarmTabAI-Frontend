import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/widget/shelf_row.dart';
import '../../models/shelf.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../nav tab/shelf_tab_view.dart';

class HomeRecentlyViewed extends StatelessWidget {
  final int userId; // Pass this from parent widget

  const HomeRecentlyViewed({
    super.key,
    required this.userId,
  });

  Future<List<Shelf>> fetchRecentlyViewed(int userId) async {
    final response = await http.get(Uri.parse('http://app.farmtab.my:4000/recently-viewed/$userId'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Shelf.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load recently viewed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recently Viewed",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: media.width * 0.01),
        FutureBuilder<List<Shelf>>(
          future: fetchRecentlyViewed(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No recently viewed shelves.");
            }

            final shelves = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shelves.length,
              itemBuilder: (context, index) {
                final shelf = shelves[index];
                return ShelfRow(
                  shelf: shelf,
                  onArrowTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShelfTabView(shelf: shelf),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        SizedBox(height: media.width * 0.05),
      ],
    );
  }
}
