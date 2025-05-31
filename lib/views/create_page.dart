import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/services/phone_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _specificationController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final success = await PhoneService().createPhone(
      name: _nameController.text,
      brand: _brandController.text,
      price: _priceController.text,
      specification: _specificationController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (success) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = 'Failed to create Data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Movie')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (e) => e == null || e.isEmpty ? "Enter Name" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Brand Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (e) => e == null || e.isEmpty ? "Enter Brand" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (e) => e == null || e.isEmpty ? "Enter Price" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _specificationController,
                decoration: InputDecoration(
                  labelText: 'Spec Phone',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (e) => e == null || e.isEmpty ? "Enter Spec" : null,
              ),
              SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child:
                      _isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
