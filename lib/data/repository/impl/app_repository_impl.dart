import 'package:currensy_converter/data/model/response/currency_model.dart';
import 'package:currensy_converter/data/repository/app_repository.dart';
import 'package:currensy_converter/data/source/remote/api/impl/api_service_impl.dart';

class AppRepositoryImpl extends AppRepository{

  final apiService = ApiServiceImpl();

  @override
  Future<List<CurrencyModel>> getCurrency(String lang, String selectedDate) async{
    final result = await apiService.getCurrency(lang, selectedDate);
    return result;
  }

}