abstract class Payment {
  void pay(double amount);
}

class CashPayment implements Payment {
  @override
  void pay(double amount) {
    print("Paid \$${amount.toStringAsFixed(2)} using cash.");
  }
}

class CreditPayment implements Payment {
  @override
  void pay(double amount) {
    print("Paid \$${amount.toStringAsFixed(2)} using credit card.");
  }
}

class PaymentProcessor {
  final Payment payment;

  PaymentProcessor(this.payment);

  void processPayment(double amount) {
    payment.pay(amount);
  }
}

void main() {
  Payment cash = CashPayment();
  Payment credit = CreditPayment();

  PaymentProcessor cashProcessor = PaymentProcessor(cash);
  cashProcessor.processPayment(100.0);

  PaymentProcessor creditProcessor = PaymentProcessor(credit);
  creditProcessor.processPayment(250.0);
}
