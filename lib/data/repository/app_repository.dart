import '../model/response/currency_model.dart';

abstract class AppRepository{
  Future<List<CurrencyModel>> getCurrency(String lang, String selectedDate);
}