import 'package:flutter/material.dart';
import 'package:pokedex/services/pokemon_api.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Map<String, dynamic> currentData = {};
  String currentName = '';
  int currentNumber = 0;
  String currentNumberString = '';
  bool Loading = true;

  Future<void> pokemonUpdateHandler(int salto) async {
    PokemonApi.searchPokemon(currentNumber + salto).then(
      (loaded) => setState(() {
        currentNumber += salto;
        if (currentNumber < 10) {
          currentNumberString = "00$currentNumber";
        } else if (currentNumber < 100) {
          currentNumberString = "0$currentNumber";
        }
        currentData = loaded;
        currentName = currentData["name"];
        currentName = currentName[0].toUpperCase() + currentName.substring(1);
        Loading = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    pokemonUpdateHandler(1);
  }

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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(254, 209, 106, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(254, 209, 106, 1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              height: 500,
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 20,
                    height: 300,
                    width: 300,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(70),
                            ),
                            color: Color.fromRGBO(249, 122, 0, 1),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 30,
                            bottom: 50,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFFFF4E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 120,
                    child:
                        Loading
                            ? CircularProgressIndicator()
                            : Column(
                              children: [
                                Text(currentName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                Image.network(
                                  'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/$currentNumberString.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                  ),
                  Positioned(
                    top: 110,
                    left: 220,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          Loading = true;
                          pokemonUpdateHandler(1);
                        });
                      },
                      icon: Icon(Icons.arrow_right_sharp, size: 100),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 10,
                    child: IconButton(
                      onPressed: () {pokemonUpdateHandler(-1);},
                      icon: currentNumber != 1? Icon(Icons.arrow_left_sharp, size: 100): Text(''),
                    ),
                  ),
                  Positioned(
                    left: 155,
                    top: 40,
                    child: Row(
                      children: [
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 290,
                    left: 70,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 290,
                    left: 230,
                    child: Column(
                      children: [
                        Container(
                          height: 3,
                          width: 70,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 3,
                          width: 70,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 3,
                          width: 70,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 400,
                    left: 60,
                    child: Container(
                      height: 70,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.8),
                        ),
                        color: const Color.fromARGB(255, 121, 228, 124),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 350,
                    left: 250,
                    child: Container(
                      height: 100,
                      width: 30,
                      decoration: BoxDecoration(color: Color(0xFF232323)),
                    ),
                  ),
                  Positioned(
                    top: 386,
                    left: 215,
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(color: Color(0xFF232323)),
                    ),
                  ),
                  Positioned(
                    top: 330,
                    left: 20,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 32, 32, 32),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 345,
                    left: 75,
                    child: Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 345,
                    left: 150,
                    child: Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF7AC74C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
