import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseService {
  late Connection _connection;

  Future<void> initDatabase() async {
    try {
      _connection = await Connection.open(
        Endpoint(
          host: dotenv.env['DB_HOST'] ?? '',      // Your EC2 public IP
          database: dotenv.env['DB_NAME'] ?? '',   // Your database name
          username: dotenv.env['DB_USERNAME'] ?? '',
          password: dotenv.env['DB_PASSWORD'] ?? '',
        ),
        settings: ConnectionSettings(
            sslMode: SslMode.disable  // Enable SSL in production
        ),
      );
      print('Database connected successfully');
    } catch (e) {
      print('Failed to connect to database: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> query(String query, [List<dynamic>? params]) async {
    try {
      final results = await _connection.execute(query, parameters: params);
      return results.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      print('Query failed: $e');
      rethrow;
    }
  }

  Future<void> closeConnection() async {
    await _connection.close();
  }
}