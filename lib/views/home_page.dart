import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/models/phone_model.dart';
import 'package:responsi_prak_mobile/services/phone_service.dart';
import 'package:responsi_prak_mobile/views/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Phone>> _phoneFuture;

  @override
  void initState() {
    super.initState();
    print("jalan");
    _phoneFuture = PhoneService().fetchPhones();
    print(_phoneFuture);
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
              Navigator.pushNamed(context, '/fav');
            },
            icon: Icon(Icons.favorite),
            tooltip: "Create Data",
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: _phoneFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          }
          final phones = snapshot.data!;
          return ListView.builder(
            itemCount: phones.length,
            itemBuilder: (context, index) {
              final phone = phones[index];
              return ListTile(
                leading:
                    phone.imgUrl.isNotEmpty
                        ? Image.network(
                          phone.imgUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : Icon(Icons.phone, size: 50),
                title: Text(phone.name),
                subtitle: Text(
                  "Brand : ${phone.brand} | Price : ${phone.price}",
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
