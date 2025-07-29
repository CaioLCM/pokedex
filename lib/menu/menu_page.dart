import 'package:flutter/material.dart';
import 'package:pokedex/menu/widgets/pokebola.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4A4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, right: 25, left: 25),
            decoration: BoxDecoration(
              color: Color.fromRGBO(254, 209, 106, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.list, color: Color.fromRGBO(56, 102, 65, 1)),
                Image.asset('assets/images/asipoke2.png', height: 100),
                Icon(
                  Icons.favorite_border,
                  color: Color.fromRGBO(56, 102, 65, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
