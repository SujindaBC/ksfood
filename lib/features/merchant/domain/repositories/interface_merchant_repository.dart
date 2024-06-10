import 'package:ksfood/features/merchant/data/models/merchant.dart';

abstract class IMerchantRepository {
  IMerchantRepository();

  Stream<List<Merchant>?> get allMerchants;
}
