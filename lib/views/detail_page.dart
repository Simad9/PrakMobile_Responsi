import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/models/phonedetail_model.dart';
import 'package:responsi_prak_mobile/services/phone_service.dart';

class DetailPage extends StatefulWidget {
  final int phoneId;
  const DetailPage({super.key, required this.phoneId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<PhoneDetail> _phoneDetailFuture;

  @override
  void initState() {
    super.initState();
    _phoneDetailFuture = PhoneService().fetchDetailPhone(widget.phoneId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Detail")),
      body: FutureBuilder<PhoneDetail>(
        future: _phoneDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Movie not found.'));
          }
          final phone = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                      phone.imgUrl.isNotEmpty
                          ? Image.network(phone.imgUrl, height: 200)
                          : Icon(Icons.movie, size: 120),
                ),
                SizedBox(height: 16),
                Text(
                  phone.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Brand : ${phone.brand}', style: TextStyle(fontSize: 16)),
                Text('Price: ${phone.price}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 12),
                Text(
                  'Spesification:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(phone.specification),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: {'id': phone.id},
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final tempContext = Navigator.of(context);
                        final success = await PhoneService().deletePhone(
                          phone.id,
                        );
                        if (success) {
                          tempContext.pushNamed('/');
                        } else {}
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
