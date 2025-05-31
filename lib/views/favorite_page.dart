import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/models/phone_model.dart';

class FavoritePage extends StatefulWidget {
  final List<Phone> favData;
  final void Function(Phone) onToggleFavorite;

  const FavoritePage({
    super.key,
    required this.favData,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<void> _refreshRender() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Favorite")),
      body:
          widget.favData.isEmpty
              ? Center(child: Text("Not Favorite Phone"))
              : ListView.builder(
                itemCount: widget.favData.length,
                itemBuilder: (contex, index) {
                  final phone = widget.favData[index];
                  return ListTile(
                    leading: Image.network(phone.imgUrl),
                    title: Text(phone.name),
                    trailing: IconButton(
                      onPressed: () {
                        widget.onToggleFavorite(phone);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${phone.name} dihapus dari favorit'),
                          ),
                        );
                        _refreshRender();
                      },
                      icon: Icon(Icons.favorite),
                    ),
                  );
                },
              ),
    );
  }
}
