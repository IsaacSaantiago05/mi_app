import 'dart:async';

import 'package:sembast_web/sembast_web.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  final _store = intMapStoreFactory.store('usuarios');

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final factory = databaseFactoryWeb;
    return await factory.openDatabase('mi_app.db');
  }

  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    final existing = await _store.findFirst(
      db,
      finder: Finder(filter: Filter.equals('email', usuario['email'])),
    );

    if (existing != null) {
      throw Exception('Correo duplicado');
    }

    return await _store.add(db, usuario);
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await database;
    final records = await _store.find(db);
    return records.map((record) {
      final value = Map<String, dynamic>.from(record.value);
      value['id'] = record.key;
      return value;
    }).toList();
  }

  Future<void> cerrar() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
