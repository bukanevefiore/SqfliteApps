import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqfliteapps/models/ogrenci.dart';

class DataBaseHelper {

  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  String _ogrenciTablo = "ogrenci";
  String _columnID = "id";
  String _columnIsim = "isim";
  String _columnAktif = "aktif";


  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      print("DbHelper null dı olusturuldu");
      return _dataBaseHelper;
    } else {
      print("DbHelper null değildi var olan oluşturuldu");
      return _dataBaseHelper;
    }
  }

  DataBaseHelper._internal();


  // veri tabanını getirme işlemi
  Future<Database> _getDataBase() async {
    if (_database == null) {
      print("DbHelper null dı olusturulacak");
      _database = await _initializeApiDLData();
      return _database;
    }
    else {
      print("DbHelper null değildi var olan kullanılacak");
      return _database;
    }
  }

// telefonun hafızasını gidip var olan veritabanıın yolunu bulma işlemi
  _initializeApiDLData() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "ogrenci.db");
    print("DB Pathi: " + dbPath);
    var ogrenciDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  // veri tabanında tablo oluşturma
  FutureOr<void> _createDB(Database db, int version) async {
    print("create db çalıştı tablo oluşturulacak");
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnID INTEGER PRİMARY KEY AUTOINCREMENT, $_columnIsim TEXT, $_columnAktif INTEGER)");
  }

  ogrenciEkle(Ogrenci ogrenci) async {
    var db = await _getDataBase();
    var sonuc = await db.insert(
        _ogrenciTablo, ogrenci.dbyeYazmakIcinMapeDonustur(),
        nullColumnHack: "$_columnID");
    print("ogrenci dbye eklendi " + sonuc.toString());
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async{
    var db = await _getDataBase();
    var sonuc = await db.query(_ogrenciTablo, orderBy: '$_columnID DESC');
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenci ogrenci) async {
    var db = await _getDataBase();
    var sonuc = await db.update(_ogrenciTablo, ogrenci.dbyeYazmakIcinMapeDonustur(), where: '$_columnID = ?', whereArgs: [ogrenci.id]);
  }

  Future<int> ogrenciSil(int id) async {
    var db = await _getDataBase();
    var sonuc = await db.delete(_ogrenciTablo, where: '$_columnID = ?',whereArgs: [id]);
    return sonuc;
  }

  // tablo silme işlemi
  Future<int> tumOgrencileriSil() async {
    var db = await _getDataBase();
    var sonuc = await db.delete(_ogrenciTablo);
    return sonuc;
  }

}