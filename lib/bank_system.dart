abstract class InterestBearing {
  void calculateInterest();
}

abstract class BankAccount {
  final String _accountNumber;
  final String _accountHolderName;
  double _balance;

  final List<String> _transactionHistory = [];


  // Constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // Setter with validation
  set balance(double amount) {
    if (amount < 0) {
      print("Balance cannot be negative!");
    } else {
      _balance = amount;
    }
  }

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  void recoordTransaction(String details){
    _transactionHistory.add("$DateTime.now()}: $details");
  }

 

  // Display method
  void displayInfo() {
    print("\nAccount Information:");
    print("Account Number: $_accountNumber");
    print("Holder Name: $_accountHolderName");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
  }
}

class SavingsAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 500.0;
  static const double _interestRate = 0.02;
  int _withdrawals = 0;

  SavingsAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    _balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Savings Account.");
  }

  @override
  void withdraw(double amount) {
    if (_withdrawals >= 3) {
      print("Withdrawal limit reached (3 per month).");
    } else if (balance - amount < _minBalance) {
      print("Cannot withdraw! Minimum balance of \$$_minBalance required.");
    } else {
      _balance -= amount;
      _withdrawals++;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Savings Account.");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * _interestRate;
    _balance += interest;
    print("Interest of \$${interest.toStringAsFixed(2)} added to Savings Account.");
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    _balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Checking Account.");
  }

  @override
  void withdraw(double amount) {
    _balance -= amount;
    if (balance < 0) {
      _balance -= _overdraftFee;
      print("Overdraft! Fee of \$$_overdraftFee charged.");
    }
    print("Withdrew \$${amount.toStringAsFixed(2)} from Checking Account.");
  }
}

// Premium Account (Interest-bearing)
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000.0;
  static const double _interestRate = 0.05;

  PremiumAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    _balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Premium Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < _minBalance) {
      print("Cannot withdraw! Minimum balance of \$$_minBalance required.");
    } else {
      _balance -= amount;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Premium Account.");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * _interestRate;
    _balance += interest;
    print("Interest of \$${interest.toStringAsFixed(2)} added to Premium Account.");
  }
}

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000.0;

  StudentAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    if (balance + amount > _maxBalance) {
      print("Deposit exceeds maximum balance limit of \$$_maxBalance.");
    } else {
      _balance += amount;
      print("Deposited \$${amount.toStringAsFixed(2)} to Student Account.");
      recordTransaction("Deposited \$${amount.toStringAsFixed(2)}");
    }
  }

  @override
  void withdraw(double amount) {
    if (balance < amount) {
      print("Insufficient funds!");
    } else {
      _balance -= amount;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Student Account.");
      recordTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
    }
  }
}


// Bank Class: Manages all accounts
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created successfully for ${account.accountHolderName}!");
  }

  BankAccount? findAccount(String accountNumber) {
    for (var acc in _accounts) {
      if (acc.accountNumber == accountNumber) return acc;
    }
    print("Account not found!");
    return null;
  }

  void transfer(String fromAccNo, String toAccNo, double amount) {
    var from = findAccount(fromAccNo);
    var to = findAccount(toAccNo);

    if (from != null && to != null) {
      from.withdraw(amount);
      to.deposit(amount);
      print("Transferred \$${amount.toStringAsFixed(2)} from ${from.accountHolderName} to ${to.accountHolderName}.");
    } else {
      print("Transfer failed: One or both accounts not found.");
    }
  }

  void applyMonthlyInterest(){
    for(var acc in _accounts){
      if (acc is InterestBearing){
        acc.calculateInterest();
      }
    }
    print( "Monthly interest applied to all interest-bearing account.");
  }

  

  void generateReport() {0
    print("\nBank Report");
    for (var acc in _accounts) {
      acc.displayInfo();
    }
    print("==========================\n");
  }
}

void main() {
  Bank bank = Bank();

  // Creating accounts
  var acc1 = SavingsAccount("S001", "Anshuya", 2000);
  var acc2 = CheckingAccount("C001", "Lily", 500);
  var acc3 = PremiumAccount("P001", "Daisy", 18000);
  var acc4 = StudentAccount("ST001", "Muffins", 5000); 

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  // Operations
  acc1.withdraw(200);
  acc1.calculateInterest();
  acc2.withdraw(400);
  acc3.withdraw(3000);
  acc3.calculateInterest();

  // Transfer money
  bank.transfer("S001", "C001", 100);

  bank.applyMonthlyInterest();

  // Generate report
  bank.generateReport();
}
