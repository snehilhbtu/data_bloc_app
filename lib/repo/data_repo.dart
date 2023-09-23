import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("data");

  Future<void> create({required name, required price}) async {
    try {
      await _fireCloud.add({"name": name, "price": price});
    } on FirebaseException catch (e) {
      if (kDebugMode) print("Failed with error '${e.code}':${e.message}");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
