class Database {
  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

  void createDatabase() {
    print("Database instance is being used.");
  }
}

class Client {
  void checkSingleton() {
    Database db1 = Database();
    Database db2 = Database();

    print("Are both instances the same? \${db1 == db2}");
  }
}

void main() {
  Client client = Client();
  client.checkSingleton();
}