import 'package:flutter/material.dart';
import 'database_services.dart';


class DatabaseTestPage extends StatefulWidget {
  @override
  _DatabaseTestPageState createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  final DatabaseService _db = DatabaseService();
  String _status = 'Not tested yet';
  bool _isLoading = false;
  List<Map<String, dynamic>> _testData = [];

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing connection...';
    });

    try {
      await _db.initDatabase();
      setState(() {
        _status = 'Connection successful! ✅';
      });
    } catch (e) {
      setState(() {
        _status = 'Connection failed: $e ❌';
      });
      return;
    }

    // Test query
    try {
      final results = await _db.query(
          'SELECT * FROM temperature_data ORDER BY timestamp DESC LIMIT 10'
      );
      setState(() {
        _testData = results;
        _status += '\nQuery successful! ✅';
      });
    } catch (e) {
      setState(() {
        _status += '\nQuery failed: $e ❌';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _db.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Connection Test'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _testConnection,
                child: Text('Test Database Connection'),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                Text(
                  _status,
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              if (_testData.isNotEmpty) ...[
                Text(
                  'Sample Data:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true, // Ensures the ListView does not take infinite height
                  physics: NeverScrollableScrollPhysics(), // Prevents scrolling inside the ListView
                  itemCount: _testData.length,
                  itemBuilder: (context, index) {
                    final row = _testData[index];
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: row.entries.map((entry) =>
                              Text('${entry.key}: ${entry.value}')
                          ).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}