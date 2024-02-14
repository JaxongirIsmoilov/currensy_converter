part of 'currency_bloc.dart';

@immutable
abstract class CurrencyEvent {}

class InitialCurrencyEvent extends CurrencyEvent{
  final String lang, date;

  InitialCurrencyEvent(this.lang, this.date);
}
