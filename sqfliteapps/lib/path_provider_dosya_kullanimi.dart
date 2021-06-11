import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PathProviderDosyaKullanimi extends StatefulWidget {
  @override
  _PathProviderDosyaKullanimiState createState() => _PathProviderDosyaKullanimiState();
}

class _PathProviderDosyaKullanimiState extends State<PathProviderDosyaKullanimi> {

  var myTextController = TextEditingController();

  // olusturulacak dosyanın klasor yolu
  Future<String> get getKlasorYolu async {
    Directory klasor = await getApplicationDocumentsDirectory();
    debugPrint("Klasorun pathi: " + klasor.path);
    return klasor.path;
  }

  // dosya olustur
  Future<File> get dosyaOlustur async {
    var olusturulacakDosyaninKlasorununYolu = await getKlasorYolu;
    return File(olusturulacakDosyaninKlasorununYolu + "/myDosya.txt");
  }

  // dosya okuma işlemi
  Future<String> dosyaOku() async {
    try {
      var myDosya = await dosyaOlustur;
      String dosyaIcerigi = await myDosya.readAsString();
      return dosyaIcerigi;
    } catch (exception) {
      return "Hataaa  $exception";
    }
  }

  // dosyaya yaz
  Future<File> dosyayaYaz(String yazilacakString) async {
    var myDosya = await dosyaOlustur;
    return myDosya.writeAsString(yazilacakString);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dosya İşlemleri-Path Provider"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Buraya yazılacal değerler dosyaya kaydedilir",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _dosyaYaz,
                  child: Text("dosya yaz"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white38)),
                ),
                TextButton(
                  onPressed: _dosyaOku,
                  child: Text("dosya oku"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white38)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _dosyaYaz() {
    dosyayaYaz(myTextController.text.toString());
  }

  void _dosyaOku() async {
    //debugPrint(await dosyaOku());
    dosyaOku().then((icerik) => debugPrint(icerik));
  }


}
