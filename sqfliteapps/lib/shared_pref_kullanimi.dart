import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKullanimi extends StatefulWidget {
  @override
  _SharedPrefKullanimiState createState() => _SharedPrefKullanimiState();
}

class _SharedPrefKullanimiState extends State<SharedPrefKullanimi> {

  String isim;
  int id;
  bool cinsiyet;
  var formKey=GlobalKey<FormState>();
  var mySharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sf) => mySharedPreferences=sf);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mySharedPreferences.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Pref Kullanımı"),),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    isim=deger;
                  },
                  decoration: InputDecoration(
                    labelText: "İsminizi girin",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    id=int.parse(deger);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "TC girin",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(value: true, groupValue: cinsiyet,
                    onChanged: (secildi){
                  setState(() {
                    cinsiyet=secildi;
                  });
                    },
                  title: Text("Erkek"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(value: false, groupValue: cinsiyet,
                    onChanged: (secildi){
                      setState(() {
                        cinsiyet=secildi;
                      });
                    },
                  title: Text("Kadın"),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: _ekle,
                    child: Text('Kaydet'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: _goster,
                    child: Text('Göster'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: _sil,
                    child: Text('Sil'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ekle() async{
    formKey.currentState.save();
    await (mySharedPreferences as SharedPreferences).setString("myIsim", isim);
    await (mySharedPreferences as SharedPreferences).setInt("myId", id);
    await (mySharedPreferences as SharedPreferences).setBool("mycinsiyet", cinsiyet);
  }

  void _goster() {
    debugPrint("Okunan isim: "+(mySharedPreferences as SharedPreferences).getString("myIsim") ?? "NULL");
    debugPrint("Okunan id: "+(mySharedPreferences as SharedPreferences).getInt("myId").toString() ?? "NULL" );
    debugPrint("Okunan cinsiyet erkek mi ? : "+(mySharedPreferences as SharedPreferences).getBool("mycinsiyet").toString() ?? "NULL");

  }

  void _sil() {
    (mySharedPreferences as SharedPreferences).remove("myIsim");
    (mySharedPreferences as SharedPreferences).remove("myId");
    (mySharedPreferences as SharedPreferences).remove("mycinsiyet");
  }
}
