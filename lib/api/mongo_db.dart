import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

import '../constant.dart';

class MongoDB {
  static Db? db;
  static DbCollection? userCollection;

  // static late var userCollection;

  static Future<void> connect() async {

    try {
      db = await Db.create(MONGO_CONN_URL);
      await db!.open(); // Use db! to assert that db is not null
      inspect(db);

      // Check server status
      var status = await db!.serverStatus();
      print("Server Status --> $status");

      // Initialize the user collection
      userCollection = db!.collection('users');
      print('Connected to MongoDB and userCollection initialized');

      // Fetch initial data from the collection
      var findStudent = await userCollection!.find().toList();
      print('Documents in collection: ${findStudent.toString()}');

    } catch (e) {
      // Log the error
      print('Error connecting to MongoDB: $e');

      // Close the database if it was opened
      if (db != null && db!.isConnected) {
        await db!.close();
      }
    }
  }

  // Insert data into MongoDB
  static Future<String> insert(dynamic data) async {
    if (db == null || !db!.isConnected) {
      return 'Database is not connected';
    }
    if (userCollection == null) {
      return 'User collection is not initialized. Ensure connect() is called.';
    }
    try {
      var result = await userCollection!.insertOne(data.toJson());
      return result.isSuccess ? "Inserted Successfully" : "Insert Failed";
    } catch (e) {
      log("Error When Inserting Data: $e");
      return 'Failed to insert data: ${e.toString()}';
    }
  }

  // Optional: Method to close the connection
  static Future<void> close() async {
    if (db != null && db!.isConnected) {
      await db!.close();
      print('Database connection closed');
    }
  }
}