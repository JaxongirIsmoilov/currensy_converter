import 'package:currensy_converter/data/model/response/currency_model.dart';
import 'package:currensy_converter/data/source/remote/api/api_service.dart';
import 'package:dio/dio.dart';

class ApiServiceImpl extends ApiService{

  final dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://cbu.uz',
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      )
  );
  @override
  Future<List<CurrencyModel>> getCurrency(String lang, String selectedDate) async{
    try{
      var result = await dio.get('/$lang/arkhiv-kursov-valyut/json/all/$selectedDate/',);
      return (result.data as List).map((currency) => CurrencyModel.fromJson(currency)).toList();
    }on DioException catch(e){
      print(e.message.toString());
        return [];
    }
  }

}