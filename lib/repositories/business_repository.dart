import 'package:optifila/models/business_model.dart';

abstract class BusinessRepository {
  Future<List<BusinessModel>> getBusiness();
}