class CurrencyRate {
  final String date;
  final double rate;

  CurrencyRate({required this.date, required this.rate});

  factory CurrencyRate.fromJson(String date, Map<String, dynamic> json) {
    return CurrencyRate(
      date: date,
      rate: json['IDR'].toDouble(),
    );
  }
}

class CurrencyTimeSeries {
  final double amount;
  final String base;
  final String startDate;
  final String endDate;
  final List<CurrencyRate> rates;

  CurrencyTimeSeries({
    required this.amount,
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  factory CurrencyTimeSeries.fromJson(Map<String, dynamic> json) {
    List<CurrencyRate> rates = [];
    json['rates'].forEach((date, rateData) {
      rates.add(CurrencyRate.fromJson(date, rateData));
    });

    return CurrencyTimeSeries(
      amount: json['amount'].toDouble(),
      base: json['base'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      rates: rates,
    );
  }
}
