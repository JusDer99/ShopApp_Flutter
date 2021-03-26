import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (innerContext) => AlertDialog(
              title: Text('ເຈົ້າແນ່ໃຈບໍ?'),
              content: Text('ເຈົ້າຂອງການລົບລາຍການນີ້ບໍ?'),
              actions: <Widget>[
                FlatButton(child: Text('ບໍ່'), onPressed: (){
                  Navigator.of(innerContext).pop(false);
                },),
                FlatButton(child: Text("ຕົກລົງ"), onPressed: (){
                  Navigator.of(innerContext).pop(true);
                },)
              ],
            ),
        );
      },
      onDismissed: (direction) {
        // if(direction == DismissDirection.endToStart) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        // }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FittedBox(
                child: Text("$price ກີບ"),
              ),
            )),
            title: Text(title),
            subtitle: Text("ລວມທັງໝົດ: ${(price * quantity)} ກີບ"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
