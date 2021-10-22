class BillDB {
  BillDB._();

  factory BillDB() => sharedInstance();

  static BillDB sharedInstance() {
    return _instance;
  }

  static BillDB _instance = BillDB._();
}
