import 'package:flutter/material.dart';
import 'package:food_order_app/model/food.dart';
import 'package:food_order_app/repository/food_repository.dart';
import 'package:food_order_app/util/color.dart';

class CartCard extends StatelessWidget {
  String id;
  String name;
  String imgUrl;
  String price;
  String salePrice;
  int quantity;
  String totalPrice;
  CartCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.imgUrl,
      required this.price,
      required this.salePrice,
      required this.quantity, required this.totalPrice})
      : super(key: key);

  _addToCart() async {
    Food food = Food(
        id: id,
        name: name,
        describe: '',
        price: price,
        salePrice: salePrice,
        image: imgUrl);

    await FoodRepository().addToCart(food);
  }

  _removeFromCart() async {
    await FoodRepository().decreaseQuantity(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: NetworkImage(imgUrl),
            width: 60,
            height: 80,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _removeFromCart,
                    icon: Icon(Icons.remove),
                    color: ThemeBgColor,
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    onPressed: _addToCart,
                    icon: Icon(Icons.add),
                    color: ThemeBgColor,
                  ),
                ],
              )
            ],
          ),
          Text(
            totalPrice,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
