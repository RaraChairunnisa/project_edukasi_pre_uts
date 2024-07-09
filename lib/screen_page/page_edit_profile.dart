import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/model_profil.dart';
import '../utils/session_manager.dart';

class PageEditProfile extends StatefulWidget {
  const PageEditProfile({super.key});

  @override
  State<PageEditProfile> createState() => _PageEditProfileState();
}

class _PageEditProfileState extends State<PageEditProfile> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNoHp = TextEditingController();
  String? userName, name, email, nohp;

  @override
  void initState() {
    super.initState();
    getDataSession();
  }

  // Untuk mendapatkan sesi
  Future<void> getDataSession() async {
    await session.getSession().then((value) {
      print('Data sesi ..' + value.toString());
      setState(() {
        userName = session.userName;
        name = session.userName;
        // email = session.email;
        // nohp = session.nohp;

        // Set nilai pada TextFormField
        txtUsername.text = userName ?? '';
        txtNama.text = name ?? '';
        txtEmail.text = email ?? '';
        txtNoHp.text = nohp ?? '';
      });
    });
  }

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //Proses untuk hit API
  bool isLoading = false;

  Future<ModelProfile?> updateAccount() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
          Uri.parse('http://172.20.10.7/edukasi_server2/updateUser.php'),
          body: {
            "username": txtUsername.text,
            "email": txtEmail.text,
            "nama": txtNama.text,
            "nohp": txtNoHp.text
          }
      );

      print('Response JSON: ${response.body}');

      ModelProfile data = modelProfileFromJson(response.body);

      //Cek kondisi
      if (data.value == 1) {
        //Kondisi ketika berhasil register
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );

          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => PageEditProfile()
          ), (route) => false);
        });
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txtNama,
                decoration: InputDecoration(
                  hintText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: txtUsername,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: txtNoHp,
                decoration: InputDecoration(
                  hintText: 'No HP',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 1, color: Colors.blueGrey)
                ),
                onPressed: () {
                  if (keyForm.currentState?.validate() == true) {
                    updateAccount();
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
