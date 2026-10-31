import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalculationHistory {
  final int? id;
  final double loanAmount;
  final double interestRate;
  final int loanTenure;
  final double emiAmount;
  final double totalInterest;
  final double totalPayment;
  final String currency;
  final DateTime createdAt;
  final String breakdown;

  CalculationHistory({
    this.id,
    required this.loanAmount,
    required this.interestRate,
    required this.loanTenure,
    required this.emiAmount,
    required this.totalInterest,
    required this.totalPayment,
    required this.currency,
    required this.createdAt,
    required this.breakdown,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'loanAmount': loanAmount,
    'interestRate': interestRate,
    'loanTenure': loanTenure,
    'emiAmount': emiAmount,
    'totalInterest': totalInterest,
    'totalPayment': totalPayment,
    'currency': currency,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'breakdown': breakdown,
  };

  factory CalculationHistory.fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      id: map['id'],
      loanAmount: map['loanAmount'],
      interestRate: map['interestRate'],
      loanTenure: map['loanTenure'],
      emiAmount: map['emiAmount'],
      totalInterest: map['totalInterest'],
      totalPayment: map['totalPayment'],
      currency: map['currency'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      breakdown: map['breakdown'],
    );
  }
}

class DatabaseService extends GetxService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'emi_calculator.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculation_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loanAmount REAL NOT NULL,
        interestRate REAL NOT NULL,
        loanTenure INTEGER NOT NULL,
        emiAmount REAL NOT NULL,
        totalInterest REAL NOT NULL,
        totalPayment REAL NOT NULL,
        currency TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        breakdown TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCalculation(CalculationHistory calculation) async {
    final db = await database;
    return await db.insert('calculation_history', calculation.toMap());
  }

  Future<List<CalculationHistory>> getCalculations() async {
    final db = await database;
    final maps = await db.query('calculation_history', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) => CalculationHistory.fromMap(maps[i]));
  }

  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete('calculation_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('calculation_history');
  }
}