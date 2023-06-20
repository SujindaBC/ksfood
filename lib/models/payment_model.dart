enum PaymentMethod {
  // cashOnHand,
  promptPay,
  mobileBankingKBank,
  // mobileBankingSCB,
}

class PaymentModel {
  final PaymentMethod method;
  final double amount;
  final String currency;
  final double gatewayFeeRate;

  PaymentModel({
    required this.method,
    required this.amount,
    required this.currency,
    this.gatewayFeeRate = 0.0,
  });
}

final Map<PaymentMethod, String> paymentMethodIcons = {
  // PaymentMethod.cash: Icons.money,
  PaymentMethod.promptPay: "lib/images/promptpay.png",
  PaymentMethod.mobileBankingKBank: "lib/images/kbank.png",
  // PaymentMethod.mobileBankingSCB: "lib/images/scb.png"
  // Add more payment methods and their icons here
};
