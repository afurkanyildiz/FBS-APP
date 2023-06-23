import 'package:cloud_firestore/cloud_firestore.dart';

class FiretoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(String userId, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .set({'addedAt': DateTime.now()});
  }
}

void addToFavorites(String productId) {
  final fireStoreService = FiretoreService();
  fireStoreService.addToFavorites('kullanici_Id', productId);
}
