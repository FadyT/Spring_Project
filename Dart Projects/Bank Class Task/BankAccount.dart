class BankAccount {
  // Create a BankAccount class with two variables account and balance
  String accountID;
  double balance;

  // the first constructor is for the accountID 
  BankAccount(this.accountID, this.balance);

  // the second constructor is named constructor for the balance and initializes it to 0 and accepts only accountID
  BankAccount.withoutInitialBalance(this.accountID) : balance = 0;

  // Make withdraw method : ensures the withdrawal amount is positive 
  void withdraw(double amount) {
    // checks if the balance is sufficient. If yes, deduct the amount; otherwise, it displays an error message.
    if (amount <= 0) {
      print('Withdrawal amount must be positive.');
    } else if (balance >= amount) {
      balance -= amount;
      print('Withdrawal successful. New balance: \$${balance.toStringAsFixed(2)}');
    } else {
      print('Insufficient balance.');
    }
  }

  // Make deposit method : add the amount to the balance.
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive.');
    } else {
      balance += amount;
      print('Deposit successful. New balance: \$${balance.toStringAsFixed(2)}');
    }
  }

  // Make displayAccountInfo method : prints the account ID and the current balance.
  void displayAccountInfo() {
    print('Account ID: $accountID');
    print('Current Balance: \$${balance.toStringAsFixed(2)}');
  }
}

void main() {
  // Create a BankAccount instance with initial balance
  BankAccount account1 = BankAccount('test 1', 100.0);
  account1.displayAccountInfo();

  // Create a BankAccount instance without initial balance
  BankAccount account2 = BankAccount.withoutInitialBalance('test 2');
  account2.displayAccountInfo();

  // Perform deposit and withdrawal operations
  account1.deposit(100.0);
  account1.withdraw(50.0);
  account1.withdraw(150.0); // Insufficient balance
  account1.deposit(-20.0); // Invalid deposit amount

  account2.deposit(200.0);
  account2.withdraw(50.0);
  account2.withdraw(300.0); // Insufficient balance
  account2.withdraw(-10.0); // Invalid withdrawal amount

  // Make displayAccountInfo 
  account1.displayAccountInfo();
  account2.displayAccountInfo();
}
