import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farmtab_ai_frontend/nav%20tab/shelf_tab_view.dart';
import 'package:farmtab_ai_frontend/shelf/shelf_widget/add_edit_shelf_dialog.dart';
import 'package:farmtab_ai_frontend/widget/card_small.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../models/shelf.dart';
import '../services/shelf_service.dart';
import '../services/user_service.dart';
import 'device_register.dart';

class ShelfList extends StatefulWidget {
  final int farmId;
  final String farmName;

  const ShelfList({Key? key, required this.farmId, required this.farmName}) : super(key: key);

  @override
  State<ShelfList> createState() => _ShelfListState();
}

class _ShelfListState extends State<ShelfList> {
  List<Shelf> shelfData = [];
  final ShelfService _shelfService = ShelfService();
  bool isLoading = true;
  String errorMessage = '';
  String userRole = '';
  String searchQuery = "";
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadShelves();
    _fetchUserRole();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final userService = UserService();
      final id = await userService.getUserId();
      setState(() {
        userId = id;
      });
    } catch (e) {
      print('Failed to load user ID: $e');
    }
  }


  Future<void> _loadShelves() async {
    try {
      final shelves = await _shelfService.getShelvesByFarmId(widget.farmId);
      setState(() {
        shelfData = shelves;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load shelves: $e";
      });
    }
  }

  Future<void> _fetchUserRole() async {
    try {
      final userService = UserService();
      final userProfile = await userService.getUserProfile();
      setState(() {
        userRole = userProfile['role'] ?? 'user';
      });
    } catch (e) {
      print('Failed to fetch user role: $e');
      setState(() {
        userRole = 'user'; // default fallback
      });
    }
  }

  Future<void> _showAddShelfDialog() async {
    final result = await showDialog<ShelfDialogData>(
      context: context,
      builder: (BuildContext context) => AddEditShelfDialog(dialogTitle: "Add A New Shelf"),
    );

    if (result != null) {
      try {
        await _shelfService.createShelf(
          farmId: widget.farmId,
          name: result.title,
          subtitle: result.subtitle,
          plantType: result.plantType,
          harvestDays: result.harvestDays,
          imageFile: File(result.imagePath), // convert XFile to File
        );
        _loadShelves();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding shelf: $e')));
      }
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
                currentShelf.name ?? "Site Options",
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
          title: currentShelf.name,
          subtitle: currentShelf.subtitle,
          imagePath: currentShelf.shelfImageUrl,
          plantType: currentShelf.plantType,
          harvestDays: currentShelf.harvestDays,
        ),
      ),
    );

    if (result != null) {
      try {
        final updatedShelf = await _shelfService.updateShelf(
          shelfId: currentShelf.id!,
          name: result.title,
          subtitle: result.subtitle,
          plantType: result.plantType,
          harvestDays: result.harvestDays,
          imageFile: result.imagePath.startsWith('http')
              ? null
              : File(result.imagePath),
        );

        setState(() {
          shelfData[index] = updatedShelf;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating shelf: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmation(int index) {
    final shelfId = shelfData[index].id!;
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
            style: TextStyle(fontFamily: "Poppins"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _shelfService.deleteShelf(shelfId);
                  setState(() {
                    shelfData.removeAt(index);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete shelf: $e')),
                  );
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
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
        shelf.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFA),
      floatingActionButton: userRole == 'manager'
          ? FloatingActionButton(
        onPressed: _showAddShelfDialog,
        backgroundColor: TColor.primaryColor1,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
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
        SizedBox(width: 6),
        Text(
          widget.farmName.length > 20
              ? '${widget.farmName.substring(0, 20)}...'
              : widget.farmName,
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 24,
            fontWeight: FontWeight.w600,
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

  Widget _buildShelfList(List<Shelf> filteredShelves) {
    if (isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: TColor.primaryColor1,
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontFamily: "Poppins",
            ),
          ),
        ),
      );
    }

    if (filteredShelves.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shelves,
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "No shelves found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 8),
              Text(
                searchQuery.isEmpty
                    ? "Tap the + button to add a new shelf"
                    : "Try a different search term",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: "Poppins",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final rowStartIndex = index * 2;
          if (rowStartIndex >= filteredShelves.length) return null;

          return _buildShelfRow(filteredShelves, rowStartIndex);
        },
        childCount: (filteredShelves.length + 1) ~/ 2,
      ),
    );
  }

  Widget _buildShelfRow(List<Shelf> data, int rowStartIndex) {
    final firstShelf = data[rowStartIndex];
    final hasSecondItem = rowStartIndex + 1 < data.length;
    final secondShelf = hasSecondItem ? data[rowStartIndex + 1] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Row(
          children: [
          Expanded(
          child: _buildShelfCard(firstShelf as Shelf, rowStartIndex),
    ),
            SizedBox(width: 10),
            Expanded(
              child: hasSecondItem
                  ? _buildShelfCard(secondShelf! as Shelf, rowStartIndex + 1)
                  : Container(),
            ),
          ],
      ),
    );
  }

  Widget _buildShelfCard(Shelf shelf, int index) {
    return GestureDetector(
      onLongPress: userRole == 'manager'
          ? () => _showEditDeleteMenu(context, index)
          : null,
      child: CardSmall(
        title: shelf.name,
        subtitle: shelf.subtitle,//
        image: shelf.shelfImageUrl.startsWith('http')
            ? shelf.shelfImageUrl
            : 'assets/images/placeholder.jpg',
        isFavorite: shelf.isFavourite,
        onTap: () async {
          try {
            await notifyBackendShelfSelected(shelf.id);

            // Also track recently viewed shelf

            await http.post(
              Uri.parse('http://app.farmtab.my:4000/recently-viewed'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'userId': userId,
                'shelfId': shelf.id,
              }),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShelfTabView(shelf: shelf),
              ),
            );
          } catch (e) {
            if (e.toString().contains("No device for this shelf")) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeviceRegistrationPage(shelf: shelf),
                ),
              );
            } else {
              print('Unexpected error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load shelf')),
              );
            }
          }
        },
        onFavoritePressed: (bool newValue) async {
          final shelf = shelfData[index];

          try {
            final updatedShelf = await _shelfService.updateShelf(
              shelfId: shelf.id,
              name: shelf.name,
              subtitle: shelf.subtitle,
              plantType: shelf.plantType,
              harvestDays: shelf.harvestDays,
              imageFile: null,
              isFavourite: newValue,
            );

            setState(() {
              shelfData[index] = updatedShelf;
            });
          } catch (e) {
            print('Failed to update favorite: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update favorite')),
            );
          }
        },
      ),
    );
  }
}

Future<void> notifyBackendShelfSelected(int shelfId) async {
  final response = await http.post(
    Uri.parse('http://app.farmtab.my:4000/api/devices/select-shelf'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'shelf_id': shelfId}),
  );

  if (response.statusCode != 200) {
    String errorMessage = 'Failed to notify backend about selected shelf';

    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('message')) {
        errorMessage = body['message'];
      } else {
        print('Unexpected backend response: ${response.body}');
      }
    } catch (e) {
      print('Error decoding response: ${response.body}');
    }

    throw Exception(errorMessage);
  }
}
