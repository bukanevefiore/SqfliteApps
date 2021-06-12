import 'package:flutter/material.dart';
import 'package:sqfliteapps/models/ogrenci.dart';
import 'package:sqfliteapps/path_provider_dosya_kullanimi.dart';
import 'package:sqfliteapps/shared_pref_kullanimi.dart';
import 'package:sqfliteapps/sqflite_islemleri.dart';
import 'package:sqfliteapps/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 // DataBaseHelper db2=DataBaseHelper();



  @override
  Widget build(BuildContext context) {
   // db2.ogrenciEkle(Ogrenci("emre", 1));
   // dbdenVerileriGetir();


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SqfLiteIslemleri(),
    );
  }


  /*
  void dbdenVerileriGetir() async{
    var sonuc = await db2.tumOgrenciler();
    print(sonuc.toString());
  }

   */
}

