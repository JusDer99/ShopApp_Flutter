import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = './user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('ຜະລິດຕະພັນຂອງທ່ານ'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator(),) :
          RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, productsData, _) => Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemBuilder: (_, index) => Column(
                    children: <Widget>[
                      UserProductItem(
                        id: productsData.items[index].id,
                        title: productsData.items[index].title,
                        imageUrl: productsData.items[index].imageUrl,
                      ),
                      Divider(),
                    ],
                  ),
                  itemCount: productsData.items.length,
                ),
              ),
            ),
          ),
        )
    );
  }
}