import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/services/phone_service.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _specificationController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  int? _phoneId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _phoneId == null) {
      _phoneId = args['id'];
      _getPhoneDetail();
    }
  }

  void _getPhoneDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final detail = await PhoneService().fetchDetailPhone(_phoneId!);
      _nameController.text = detail.name;
      _brandController.text = detail.brand;
      _priceController.text = detail.price.toString();
      _specificationController.text = detail.specification;
    } catch (e) {
      setState(() {
        _error = 'Failed to load movie detail';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _phoneId == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final success = await PhoneService().updatePhone(
      id: _phoneId!,
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
        _error = 'Failed to update movie';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Phone')),
      body:
          _isLoading && _phoneId == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Enter Name' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _brandController,
                        decoration: InputDecoration(
                          labelText: 'Brand',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Enter Brand' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Enter Price' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _specificationController,
                        decoration: InputDecoration(
                          labelText: 'Spec',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Enter spec' : null,
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
                                  : Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
