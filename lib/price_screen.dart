import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, double> selectedCurrencyRates = {};

  Widget getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(
          currency,
        ),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) => selectCurrency(value),
    );
  }

  Widget getIosPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      );
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) =>
          selectCurrency(currenciesList[selectedIndex]),
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();

    updateRate();
  }

  void selectCurrency(String currency) {
    selectedCurrency = currency;
    updateRate();
  }

  void updateRate() async {
    var coinData = new CoinData();
    Map<String, double> rates = {};
    for (var baseCurrency in cryptoList) {
      var rate = await coinData.getRate(baseCurrency, selectedCurrency);
      rates[baseCurrency] = rate;
    }
    setState(() {
      selectedCurrencyRates = rates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CurrencyWidget(
                    baseCurrency: cryptoList[0],
                    selectedCurrencyRate: selectedCurrencyRates[cryptoList[0]],
                    selectedCurrency: selectedCurrency),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CurrencyWidget(
                    baseCurrency: cryptoList[1],
                    selectedCurrencyRate: selectedCurrencyRates[cryptoList[1]],
                    selectedCurrency: selectedCurrency),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CurrencyWidget(
                    baseCurrency: cryptoList[2],
                    selectedCurrencyRate: selectedCurrencyRates[cryptoList[2]],
                    selectedCurrency: selectedCurrency),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({
    Key key,
    @required this.baseCurrency,
    @required this.selectedCurrencyRate,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String baseCurrency;
  final double selectedCurrencyRate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $baseCurrency = ${selectedCurrencyRate?.toStringAsFixed(2) ?? '?'} $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
