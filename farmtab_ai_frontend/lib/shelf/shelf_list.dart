import 'package:farmtab_ai_frontend/nav%20tab/shelf_tab_view.dart';
import 'package:farmtab_ai_frontend/shelf/shelf_widget/add_edit_shelf_dialog.dart';
import 'package:farmtab_ai_frontend/widget/card_small.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'shelf_widget/add_edit_shelf_dialog.dart';

class ShelfList extends StatefulWidget {
  final int farmId;

  const ShelfList({Key? key, required this.farmId}) : super(key: key);

  @override
  State<ShelfList> createState() => _ShelfListState();
}

class _ShelfListState extends State<ShelfList> {
  final List<Map<String, String>> shelfData = [
    {"title": "Shelf A", "subtitle": "Fresh Vegetables", "img": "assets/images/shelfA.jpg"},
    {"title": "Shelf B", "subtitle": "-", "img": "assets/images/shelfB.jpg"},
    {"title": "Shelf C", "subtitle": "Herbs", "img": "assets/images/shelfC.jpg"},
  ];

  String searchQuery = "";

  Future<void> _showAddShelfDialog() async {
    final result = await showDialog<ShelfDialogData>(
      context: context,
      builder: (BuildContext context) => AddEditShelfDialog(
        dialogTitle: "Add A New Shelf",
      ),
    );

    if (result != null) {
      setState(() {
        shelfData.add({
          "title": result.title,
          "subtitle": result.subtitle,
          "img": result.imagePath,
        });
      });
    }
  }

  void _showEditDeleteMenu(BuildContext context, int index) {
    final currentShelf = shelfData[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
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
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                currentShelf["title"] ?? "Site Options",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryColor1,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Shelf',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditShelfDialog(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Shelf',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    )
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditShelfDialog(int index) async {
    final currentShelf = shelfData[index];
    final result = await showDialog<ShelfDialogData>(
      context: context,
      builder: (BuildContext context) => AddEditShelfDialog(
        dialogTitle: "Edit Shelf",
        initialData: ShelfDialogData(
          title: currentShelf["title"] ?? "",
          subtitle: currentShelf["subtitle"] ?? "-",
          imagePath: currentShelf["img"] ?? "assets/images/placeholder.jpg",
        ),
      ),
    );

    if (result != null) {
      setState(() {
        shelfData[index] = {
          "title": result.title,
          "subtitle": result.subtitle,
          "img": result.imagePath,
        };
      });
    }
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Delete Shelf',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this shelf?',
            style: TextStyle(
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  shelfData.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = shelfData
        .where((shelf) =>
        shelf["title"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFA),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddShelfDialog,
        backgroundColor: TColor.primaryColor1,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildShelfList(filteredData),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 130,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildTitleRow(),
            SizedBox(height: 6),
            _buildSearchField(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: TColor.primaryColor1),
        ),
        SizedBox(width: 10),
        Text(
          "Farm A",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: "OpenSans",
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        cursorColor: TColor.primaryColor1,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Enter Shelf Name',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.withOpacity(0.6),
            fontFamily: "Poppins",
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.6),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: TColor.primaryColor1,
              width: 1.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.withOpacity(.6),
          ),
        ),
      ),
    );
  }

  Widget _buildShelfList(List<Map<String, String>> filteredData) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final rowStartIndex = index * 2;
          if (rowStartIndex >= filteredData.length) return null;

          return _buildShelfRow(filteredData, rowStartIndex);
        },
        childCount: (filteredData.length + 1) ~/ 2,
      ),
    );
  }

  Widget _buildShelfRow(List<Map<String, String>> data, int rowStartIndex) {
    final firstShelf = data[rowStartIndex];
    final hasSecondItem = rowStartIndex + 1 < data.length;
    final secondShelf = hasSecondItem ? data[rowStartIndex + 1] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Row(
          children: [
          Expanded(
          child: _buildShelfCard(firstShelf, rowStartIndex),
    ),
            SizedBox(width: 10),
            Expanded(
              child: hasSecondItem
                  ? _buildShelfCard(secondShelf!, rowStartIndex + 1)
                  : Container(),
            ),
          ],
      ),
    );
  }

  Widget _buildShelfCard(Map<String, String> shelf, int index) {
    return GestureDetector(
      onLongPress: () => _showEditDeleteMenu(context, index),
      child: CardSmall(
        title: shelf["title"] ?? "Unknown Shelf",
        subtitle: shelf["subtitle"] ?? "-",
        image: shelf["img"] ?? "assets/images/placeholder.jpg",
        isFavorite: false,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShelfTabView()),
          );
        },
        onFavoritePressed: (bool isFavorite) {
          print('Is favorite for shelf $index: $isFavorite');
        },
      ),
    );
  }
}