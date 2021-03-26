import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("ShopApp", style: TextStyle(letterSpacing: 1.5),),
            automaticallyImplyLeading: false,
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("ຮ້ານຄ້າ"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("ອໍເດີ"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(CustomRoute(builder: (routeContext) => OrdersScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("ການຈັດການຜະລິດຕະພັນ"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("ອອກຈາກລະບົບ"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
