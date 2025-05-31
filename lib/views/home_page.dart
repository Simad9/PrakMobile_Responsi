import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/models/phone_model.dart';
import 'package:responsi_prak_mobile/services/phone_service.dart';
import 'package:responsi_prak_mobile/views/detail_page.dart';
import 'package:responsi_prak_mobile/views/favorite_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Phone>> _phoneFuture;
  List<Phone> _favPhone = [];

  @override
  void initState() {
    super.initState();
    _phoneFuture = PhoneService().fetchPhones();
    _loadFavoritePhones();
  }

  Future<void> _loadFavoritePhones() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favJsonList = prefs.getStringList("favData");
    if (favJsonList == null) {
      _favPhone = [];
    } else {
      _favPhone = favJsonList.map((jsonStr) => Phone.fromJson(jsonDecode(jsonStr))).toList();
    }
    setState(() {});
  }

  Future<void> _saveFavoritePhones() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favJsonList = _favPhone.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('favData', favJsonList);
  }

  void _toggleFavorite(Phone phone) async {
    setState(() {
      bool isFav = _favPhone.any((m) => m.id == phone.id);
      if (isFav) {
        _favPhone.removeWhere((m) => m.id == phone.id);
      } else {
        _favPhone.add(phone);
      }
    });
    await _saveFavoritePhones();
  }

  bool _isFavorited(Phone phone) {
    return _favPhone.any((m) => m.id == phone.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create').then((value) {
                setState(() {
                  _phoneFuture = PhoneService().fetchPhones();
                });
              });
            },
            icon: Icon(Icons.add),
            tooltip: "Create Data",
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    favData: _favPhone,
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
            icon: Icon(Icons.favorite),
            tooltip: "Favorite",
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: _phoneFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No phones found.'));
          }
          final phones = snapshot.data!;
          return ListView.builder(
            itemCount: phones.length,
            itemBuilder: (context, index) {
              final phone = phones[index];
              final favorit = _isFavorited(phone);
              return ListTile(
                leading: phone.imgUrl.isNotEmpty
                    ? Image.network(
                        phone.imgUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.phone, size: 50),
                title: Text(phone.name),
                subtitle: Text("Brand : ${phone.brand} | Price : ${phone.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        favorit ? Icons.favorite : Icons.favorite_border,
                        color: favorit ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(phone),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final result = await PhoneService().deletePhone(phone.id);
                        if (result) {
                          setState(() {
                            _phoneFuture = PhoneService().fetchPhones();
                          });
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(phoneId: phone.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
