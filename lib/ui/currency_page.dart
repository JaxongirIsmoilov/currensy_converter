import 'package:currensy_converter/data/model/response/currency_model.dart';
import 'package:currensy_converter/data/source/local/my_preference.dart';
import 'package:currensy_converter/presenter/currency/bloc/currency_bloc.dart';
import 'package:currensy_converter/utill/status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lang/locale_keys.g.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final bloc = CurrencyBloc();
  final TextEditingController _controllerUz = TextEditingController();
  final TextEditingController _controllerOther = TextEditingController();
  String _currentDate = DateTime.now().toLocal().toString().split(' ')[0];
  bool changeCurrency = false;

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? initialDateTime = DateTime.parse(_currentDate);
    DateTime? picked = await showDatePicker(
        initialDate: initialDateTime,
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        _currentDate = picked.toString().split(" ")[0];
        bloc.add(InitialCurrencyEvent(MySharedPref.getLocal()!, _currentDate));
      });
    }
  }
  @override
  void initState() {
    _controllerOther.text = '1';
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF4D2B89),
    ));
    bloc.add(InitialCurrencyEvent(MySharedPref.getLocal() ?? "", _currentDate));
    super.initState();
  }

  String changeLocal(CurrencyModel model) {
    String local = MySharedPref.getLocal() ?? '';
    String result = "";
    switch (local) {
      case 'uz':
        {
          result = model.ccyNmUz!;
          break;
        }
      case 'en':
        {
          result = model.ccyNmEn!;
          break;
        }
      case 'ru':
        {
          result = model.ccyNmRu!;
          break;
        }
    }
    return result;
  }

  String convertCurrency(String input, double rate1, double rate2) {
    if (input.isEmpty) {
      return "0.00";
    } else {
      double amount = double.tryParse(input) ?? 0.0;
      double convertedAmount = (amount * rate1) / rate2;
      return convertedAmount.toStringAsFixed(2);
    }
  }

  String convertUzsToUsd(String uzsAmount, double usdToUzsRate) {
    return convertCurrency(uzsAmount, 1, usdToUzsRate);
  }

  String convertOtherToUzs(String otherAmount, double usdToUzsRate) {
    return convertCurrency(otherAmount, 1, 1 / usdToUzsRate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<CurrencyBloc, CurrencyState>(
        listener: (BuildContext context, CurrencyState state) {},
        builder: (context, state) {
          if (state.status == Status.LOADING) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state.status == Status.SUCCESS) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: InkWell(
                      onTap: (){
                        _selectDate();
                      },
                      child: Image.asset(
                        "assets/images/calendar.png",
                        color: Colors.white,
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            builder: (context) => Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF031E2A),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await context
                                                .setLocale(const Locale("uz"));
                                            MySharedPref.saveLocal('uz');
                                          },
                                          child: Text(
                                            LocaleKeys.uzbek.tr(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            await context
                                                .setLocale(const Locale("en"));
                                            MySharedPref.saveLocal('en');
                                          },
                                          child: Text(
                                            LocaleKeys.english.tr(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            await context
                                                .setLocale(const Locale("ru"));
                                            MySharedPref.saveLocal('ru');
                                          },
                                          child: Text(
                                            LocaleKeys.russian.tr(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      child: Image.asset(
                        "assets/images/internet.png",
                        color: Colors.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                title: Text(
                  LocaleKeys.title.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.deepPurple,
                bottomOpacity: 8.0,
              ),
              body: ListView.builder(
                  itemCount: state.data?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: Card(
                            child: ExpansionTile(
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    changeLocal(state.data![index]),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "${double.parse(state.data![index].diff!) >= 0.0 ? "+" : ""}${state.data?[index].diff ?? "null"}",
                                    style: TextStyle(
                                        color: double.parse(
                                                    state.data![index].diff!) >=
                                                0.0
                                            ? Colors.greenAccent
                                            : Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    state.data?[index].nominal ?? 'null',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    state.data?[index].ccy ?? 'null',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    " =>${state.data?[index].rate ?? 'null'} UZS | ",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Image.asset(
                                    "assets/images/date.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      state.data?[index].date ?? 'null',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 8,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              changeLocal(state.data![index]),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    changeCurrency == true
                                                        ? _controllerUz
                                                        : _controllerOther,
                                                onChanged: (text) {
                                                  if (changeCurrency == true) {
                                                    String uzsAmount =
                                                        _controllerUz.text;
                                                    double usdToUzsRate =
                                                        double.parse(state
                                                                .data?[index]
                                                                .rate ??
                                                            '1');
                                                    String usdEquivalent =
                                                        convertUzsToUsd(
                                                            uzsAmount,
                                                            usdToUzsRate);
                                                    _controllerOther.text =
                                                        usdEquivalent;
                                                  } else {
                                                    String usdAmount =
                                                        _controllerOther.text;
                                                    double usdToUzsRate =
                                                        double.parse(state
                                                                .data?[index]
                                                                .rate ??
                                                            '1');
                                                    String uzsEquivalent =
                                                        convertOtherToUzs(
                                                            usdAmount,
                                                            usdToUzsRate);
                                                    _controllerUz.text =
                                                        uzsEquivalent;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText:
                                                      changeCurrency == true
                                                          ? 'UZS'
                                                          : state.data?[index]
                                                                  .ccy ??
                                                              '',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: TextField(
                                                readOnly: true,
                                                controller:
                                                    changeCurrency == true
                                                        ? _controllerOther
                                                        : _controllerUz,
                                                decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    label: changeCurrency ==
                                                            true
                                                        ? Text(state
                                                                .data?[index]
                                                                .ccy ??
                                                            '')
                                                        : const Text('UZS')),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF673bb7),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.calculate,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(LocaleKeys.calculate.tr(),
                                              style: GoogleFonts.roboto(
                                                color: const Color(0xFFFFFFFF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                    );
                  }),
            );
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }
}
