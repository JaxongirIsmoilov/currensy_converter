import 'dart:async';

import 'package:currensy_converter/data/repository/impl/app_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/response/currency_model.dart';
import '../../../utill/status.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyState()) {
    on<InitialCurrencyEvent>((event, emit) async{
      emit(state.copyWith(status: Status.LOADING));
      final repository = AppRepositoryImpl();
      try{
        final data = await repository.getCurrency(event.lang, event.date);
        emit(state.copyWith(status: Status.SUCCESS, data: data));
      }catch(e){
        emit(state.copyWith(status: Status.ERROR));
      }
    });
  }
}
