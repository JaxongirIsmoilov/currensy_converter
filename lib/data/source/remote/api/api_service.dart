import '../../../model/response/currency_model.dart';

abstract class ApiService{
  Future<List<CurrencyModel>> getCurrency(String lang, String selectedDate);
}