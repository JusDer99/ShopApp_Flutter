import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = './edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus) {
      if(_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') ||
              _imageUrlController.text.startsWith('https')
          ) ||
          (!_imageUrlController.text.endsWith('.png') ||
              !_imageUrlController.text.endsWith('.jpg') ||
              !_imageUrlController.text.endsWith('.jpeg')
          )
      ) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if(_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        Navigator.of(context).pop();
      } catch (exception) {
        await showDialog<Null>(
            context: context,
            builder: (innerContext) => AlertDialog(
              title: Text('An error occurred'),
              content: Text(exception.toString()),
              actions: <Widget>[
                FlatButton(child: Text('Okay'), onPressed: () {
                  Navigator.of(innerContext).pop();
                },)
              ],
            )
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ແກ້ໄຂຜະລິດຕະພັນ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: Colors.white,),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'ຊື່ສິນຄ້າ',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'ກະລຸນາລະບຸຊື່ສິນຄ້າ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'ລາຄາ',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'ກະລຸນາລະບຸລາຄາ!';
                  }
                  if(double.tryParse(value) == null) {
                    return 'ກະລຸນາປ້ອນໝາຍເລກທີ່ຖືກຕ້ອງ!';
                  }
                  if(double.parse(value) <= 0) {
                    return 'ກະລຸນາປ້ອນຕົວເລກທີ່ໃຫຍ່ກວ່າ 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'ຄຳອະທິບາຍ',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'ກະລຸນາລະບຸຄຳອະທິບາຍ!';
                  }
                  if(value.length < 10) {
                    return 'ຄວນມີຢ່າງໜ້ອຍ 10 ອັກຂະຫຼະຂຶ້ນໄປ!';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10,),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty ?
                    Text('ປ້ອນ URL') :
                    FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ທີ່ຢູ່ URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (value) => _saveForm(),
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'ກະລຸນາປ້ອນ URL!';
                        }
                        if(!value.startsWith('http') || !value.startsWith('https') ) {
                          return 'ກະລຸນາປ້ອນ URL ທີ່ຖືກຕ້ອງ!';
                        }
                        // if(!value.endsWith('.png') || !value.endsWith('.jpg') || !value.endsWith('.jpeg')) {
                        //   return 'Please enter a valid image url!';
                        // }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
