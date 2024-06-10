import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksfood/features/merchant/data/models/merchant.dart';
import 'package:ksfood/features/merchant/domain/repositories/interface_merchant_repository.dart';

class MerchantRepository implements IMerchantRepository {
  const MerchantRepository({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  @override
  Stream<List<Merchant>?> get allMerchants {
    return firebaseFirestore
        .collection("merchant")
        .where("isAvailable", isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Merchant.fromMap(doc.data());
      }).toList();
    });
  }
}
