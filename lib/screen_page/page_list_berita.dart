import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_edukasi_pre_uts/screen_page/page_login_api.dart';
import '../model/model_berita.dart';
import '../utils/session_manager.dart';
import 'detail_berita.dart';

class PageListBerita extends StatefulWidget {
  const PageListBerita({Key? key}) : super(key: key);

  @override
  State<PageListBerita> createState() => _PageListBeritaState();
}

class _PageListBeritaState extends State<PageListBerita> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? beritaList;
  List<Datum>? filteredBeritaList;
  String? username;

  @override
  void initState() {
    super.initState();
    session.getSession();
    getDataSession();
    fetchBerita();
  }

  Future<void> getDataSession() async {
    await Future.delayed(const Duration(seconds: 1), () {
      session.getSession().then((value) {
        setState(() {
          username = session.userName;
        });
      });
    });
  }

  Future<void> fetchBerita() async {
    try {
      final response = await http.get(
        Uri.parse("http://172.20.10.7/edukasi_server2/getBerita.php"),
      );

      if (response.statusCode == 200) {
        setState(() {
          beritaList = modelBeritaFromJson(response.body).data;
          filteredBeritaList = beritaList;
        });
      } else {
        throw Exception('Failed to load berita');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Berita'),
        backgroundColor: Colors.cyan,
        actions: [
          TextButton(onPressed: () {}, child: Text('Hi ... $username')),
          IconButton(
            onPressed: () {
              setState(() {
                session.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const PageLoginApi()),
                      (route) => false,
                );
              });
            },
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredBeritaList = beritaList
                      ?.where((element) =>
                  element.judul.toLowerCase().contains(value.toLowerCase()) ||
                      element.konten.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: beritaList == null
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
                : ListView.builder(
              itemCount: filteredBeritaList?.length ?? 0,
              itemBuilder: (context, index) {
                Datum data = filteredBeritaList![index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailBeritaPage(berita: data),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'http://172.20.10.7/edukasi_server2/gambar_berita/${data.gambar}',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              data.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              data.konten,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
