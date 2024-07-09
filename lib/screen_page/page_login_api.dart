import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_edukasi_pre_uts/screen_page/page_bottom_navigation.dart';
import 'package:project_edukasi_pre_uts/screen_page/page_register_api.dart';
import '../model/model_login.dart';
import '../utils/session_manager.dart';

class PageLoginApi extends StatefulWidget {
  const PageLoginApi({super.key});

  @override
  State<PageLoginApi> createState() => _PageLoginApiState();
}

class _PageLoginApiState extends State<PageLoginApi> {
  //untuk mendapatkan value dari text field
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  //validasi form
  GlobalKey<FormState> keyForm= GlobalKey<FormState>();

  //proses untuk hit api
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.post(
          Uri.parse('http://172.20.10.7/edukasi_server2/login.php'),
          body: {
            "username": txtUsername.text,
            "password": txtPassword.text,
          }
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ModelLogin data = modelLoginFromJson(response.body);
        // Check response value
        if (data.value == 1) {
          // Successful login
          setState(() {
            isLoading = false;
            session.saveSession(data.value ?? 0, data.id ?? "", data.username ?? "");

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${data.message}'))
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageBottomNavigationBar()),
                  (route) => false,
            );
          });
        } else {
          // Failed login
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${data.message}'))
            );
          });
        }
      } else {
        // Server error
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Server error: ${response.statusCode}'))
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Form Login'),
      ),

      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  //validasi kosong
                  validator: (val){
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtUsername,
                  decoration: InputDecoration(
                      hintText: 'Input Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                SizedBox(height: 8,),


                SizedBox(height: 8,),
                TextFormField(
                  validator: (val){
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtPassword,
                  obscureText: true,//biar password nya gak keliatan
                  decoration: InputDecoration(
                      hintText: 'Input Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),

                SizedBox(height: 15,),
                Center(child: isLoading ? Center(
                  child: CircularProgressIndicator(),
                ) : MaterialButton(onPressed: (){
                  //cara get data dari text form field

                  //cek validasi form ada kosong  atau tidk
                  if(keyForm.currentState?.validate() == true){
                    setState(() {
                      loginAccount();
                    });
                  }

                },
                  child: Text('Login'),
                  color: Colors.green,
                  textColor: Colors.white,
                ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 1, color: Colors.green)
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)
            => PageRegisterApi()
            ));
          },
          child: Text('Anda belum punya account? Silkan Register'),
        ),
      ),
    );
  }
}
