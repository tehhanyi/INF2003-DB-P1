import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

import '../constant.dart';

class MongoDB {
  static Db? db;

  MongoDB() {
    if (db == null || !db!.isConnected) {
      connect();
    }
  }

  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db!.open(); // Use db! to assert that db is not null
      inspect(db);
      // Check server status
      var status = await db!.serverStatus();
      print("Server Status --> $status");
    } catch (e) {
      // Log the error
      print('Error connecting to MongoDB: $e');
      // Close the database if it was opened
      if (db != null && db!.isConnected) {
        await db!.close();
      }
    }
  }

  static Future<void> close() async {
    if (db != null && db!.isConnected) {
      await db!.close();
      print('Database connection closed');
    }
  }

  Future<void> throwError(String e) async {
    // Close the database if it was opened
    // close();
    // Log the error
    throw ('$e');
  }

  Future<List<Map<String, dynamic>>?> viewAll(String collectionName) async {
    try {
      // Initialize the user collection
      DbCollection collection = db!.collection(collectionName);
      // Fetch initial data from the collection
      var dataList = await collection.find().toList();
      print('data in $collectionName: ${dataList.toString()}');
      return dataList;
    } catch (e) {
      throwError('Error viewAll: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> view(String collectionName, dynamic search) async {
    try {
      // Initialize the user collection
      DbCollection collection = db!.collection(collectionName);
      // Fetch initial data from the collection
      var data = await collection.find(search).toList();
      print('Find $search in $collectionName: $data');
      if (data.isNotEmpty) return data[0];
    } catch (e) {
      throwError('$e');
    }
    return null;
  }

  Future<void> insert(String collectionName, dynamic data) async {
    try {
      DbCollection collection = db!.collection(collectionName);
      var result = await collection.insertOne(data);
      print(result.isSuccess ? "Inserted Successfully" : "Insert Failed");
    } catch (e) {
      throwError('Error insert data: $e');
      // return 'Failed to insert data: ${e.toString()}';
    }
  }

  Future<void> update(String collectionName,dynamic search, dynamic data) async {
    try {
      DbCollection collection = db!.collection(collectionName);
      var result = await collection.update(search, data);
      print(result.isNotEmpty ? "Inserted Successfully" : "Insert Failed");
    } catch (e) {
      throwError('Error update data: $e');
    }
  }
}
