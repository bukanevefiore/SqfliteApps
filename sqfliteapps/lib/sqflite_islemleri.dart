import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqfliteapps/models/ogrenci.dart';
import 'package:sqfliteapps/utils/database_helper.dart';

class SqfLiteIslemleri extends StatefulWidget {
  @override
  _SqfLiteIslemleriState createState() => _SqfLiteIslemleriState();
}

class _SqfLiteIslemleriState extends State<SqfLiteIslemleri> {

  DataBaseHelper _dataBaseHelper;
  List<Ogrenci> tumOgrencilerListesi;
  var formKey=GlobalKey<FormState>();
  bool aktiflik =false;
  var _controller = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklanilanOgrenciIndexi;
  int tiklanilanOgrenciIDsi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumOgrencilerListesi = List<Ogrenci>();
    _dataBaseHelper = DataBaseHelper();
    _dataBaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for(Map okunanOgrenciMapi in tumOgrencileriTutanMapListesi) {
        tumOgrencilerListesi.add(Ogrenci.dbdenOkudugumMapiObjeyeDonustur(okunanOgrenciMapi));
      }
    }).catchError((hata) => print("hata: "+hata));
  }

  @override
  Widget build(BuildContext context) {
    /*
    Ogrenci emre=Ogrenci.withID(10,"emre",1);
    Map olusanMap=emre.dbyeYazmakIcinMapeDonustur();
    debugPrint(olusanMap['ad_soyad'].toString());

    Ogrenci kopyaEmre = Ogrenci.dbdenOkudugumMapiObjeyeDonustur(olusanMap);
    debugPrint(kopyaEmre.toString());

     */



    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("SqfLite İşlemleri"),),
      body: Container(
        child: Column(
          children: [
            Form(
              key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        controller: _controller,
                        validator: (kontrolEdilecekIsimDegeri) {
                          if(kontrolEdilecekIsimDegeri.length <3) {
                            return "en az 3 karakter olmalı";
                          }else return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Ogrenci ismini girin",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text("Aktif"),
                      value: aktiflik,
                      onChanged: (aktifMi) {
                        setState(() {
                          aktiflik = aktifMi;
                        });
                      },
                    ),
                  ],
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(child: Text("Kaydet"),color: Colors.yellowAccent,
                  onPressed: (){
                  if(formKey.currentState.validate()) {
                    _ogrenciEkle(Ogrenci(_controller.text, aktiflik == true ? 1 : 0));
                  }
                  },),
                RaisedButton(color: Colors.brown, child: Text("Güncelle"),
                  onPressed: tiklanilanOgrenciIDsi == null ? null : ()  {
                  if(formKey.currentState.validate()) {
                    _ogrenciGuncelle(Ogrenci.withID(tiklanilanOgrenciIDsi, _controller.text, aktiflik == true ? 1 : 0));
                  }
                  }, ),
                RaisedButton(color: Colors.deepOrange, child: Text("Tüm tabloyu sil"),
                  onPressed: () {
                  _tumTabloyuTemizle();
                  }, ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tumOgrencilerListesi.length,
                  itemBuilder: (context, index) {
                  return Card(
                    color: tumOgrencilerListesi[index].aktif == 1 ? Colors.green.shade200 : Colors.red.shade200,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _controller.text = tumOgrencilerListesi[index].isim;
                          aktiflik = tumOgrencilerListesi[index].aktif == 1 ? true : false;
                          tiklanilanOgrenciIndexi=index;
                          tiklanilanOgrenciIDsi=tumOgrencilerListesi[index].id;
                        });
                      },
                      title: Text(tumOgrencilerListesi[index].isim),
                      subtitle: Text(tumOgrencilerListesi[index].id.toString()),
                      trailing: GestureDetector(
                          onTap: () {
                            _ogrenciSil(tumOgrencilerListesi[index].id,index);
                          },
                          child: Icon(Icons.delete,)),
                    ),
                  );
            }),
            ),
          ],
        ),
      ),
    );
  }

  void _ogrenciEkle(Ogrenci ogrenci) async{

    var eklenenYeniOgrenciIDsi = await _dataBaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenYeniOgrenciIDsi;
    if(eklenenYeniOgrenciIDsi>0){
      setState(() {
        tumOgrencilerListesi.insert(0, ogrenci);
      });
    }
  }

  void _tumTabloyuTemizle() async {

    var silinenElemanSayisi = await _dataBaseHelper.tumOgrencileriSil();
    if(silinenElemanSayisi>0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
          content: Text(silinenElemanSayisi.toString()+ "kayıt silindi"),
      ));
      setState(() {
        tumOgrencilerListesi.clear();
      });
    }
    tiklanilanOgrenciIDsi = null;
  }

  void _ogrenciSil(int dbdebSilmeyeYarayacakID, int listedenSilmeyeYarayacakIndex) async{
    var sonuc =await _dataBaseHelper.ogrenciSil(dbdebSilmeyeYarayacakID);
    if(sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("kayıt silindi"),
      ));
      
      setState(() {
        tumOgrencilerListesi.removeAt(listedenSilmeyeYarayacakIndex);
      });
    }else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("silerken hata çıktı"),
      ));
    }
    tiklanilanOgrenciIDsi = null;
  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async{

    var sonuc = await _dataBaseHelper.ogrenciGuncelle(ogrenci);
    if(sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("kayıt güncellendi"),
      ));

      setState(() {
        tumOgrencilerListesi[tiklanilanOgrenciIndexi] = ogrenci;
      });
    }

  }
}
