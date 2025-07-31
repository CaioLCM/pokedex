import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/services/mongo_server.dart';
import 'package:pokedex/services/pokemon_api.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  Map<String, dynamic> currentData = {};
  String currentName = '';
  int currentNumber = 0;
  String currentNumberString = '';
  bool Loading = true;
  TextEditingController numberController = TextEditingController();
  bool mostrarFavoritos = false;
  bool emCaptura = false;
  String poke1Path = "assets/images/pokebola-png.png";
  String poke2Path = "assets/images/pokebola-png.png";
  String textoSucessoCaptura = '';
  bool sucessoCaptura = false;
  List<String> pokemonsCapturados = [];
  bool mostarCapturados = false;

  void navegarFavorito(int direcao, List<Map<String, dynamic>> favoritos) {
    if (favoritos.isEmpty) return;
    final idx = favoritos.indexWhere((poke) => poke['name'] == currentName);
    int novoIdx = idx + direcao;
    if (novoIdx < 0) novoIdx = favoritos.length - 1;
    if (novoIdx >= favoritos.length) novoIdx = 0;
    final novoFavorito = favoritos[novoIdx];
    setState(() {
      currentName = novoFavorito['name'];
      currentNumber = novoFavorito['id'];
      numberController.text = currentNumber.toString();
      Loading = true;
    });
    pokemonUpdateHandler(currentNumber, false);
  }

  Future<void> pokemonUpdateHandler(int num, bool saltar) async {
    if (saltar) {
      PokemonApi.searchPokemon(currentNumber + num).then(
        (loaded) => setState(() {
          currentNumber += num;
          if (currentNumber < 10) {
            currentNumberString = "00$currentNumber";
          } else if (currentNumber < 100) {
            currentNumberString = "0$currentNumber";
          } else {
            currentNumberString = currentNumber.toString();
          }
          currentData = loaded;
          currentName = currentData["name"];
          currentName = currentName[0].toUpperCase() + currentName.substring(1);
          numberController.text = currentNumber.toString();
          Loading = false;
        }),
      );
    } else {
      PokemonApi.searchPokemon(num).then(
        (Loaded) => {
          setState(() {
            currentData = Loaded;
            currentName = currentData["name"];
            currentNumber = num;
            if (currentNumber < 10) {
              currentNumberString = "00$currentNumber";
            } else if (currentNumber < 100) {
              currentNumberString = "0$currentNumber";
            } else {
              currentNumberString = currentNumber.toString();
            }
            currentName =
                currentName[0].toUpperCase() + currentName.substring(1);
            numberController.text = currentNumber.toString();
            Loading = false;
          }),
        },
      );
    }
  }

  void navegarCapturado(int direcao) {
    if (pokemonsCapturados.isEmpty) return;
    final idx = pokemonsCapturados.indexOf(currentNumber.toString());
    int novoIdx = idx + direcao;
    if (novoIdx < 0) novoIdx = pokemonsCapturados.length - 1;
    if (novoIdx >= pokemonsCapturados.length) novoIdx = 0;
    final novoCapturado = int.parse(pokemonsCapturados[novoIdx]);
    setState(() {
      currentNumber = novoCapturado;
      numberController.text = currentNumber.toString();
      Loading = true;
    });
    pokemonUpdateHandler(currentNumber, false);
  }

  @override
  void initState() {
    super.initState();
    pokemonUpdateHandler(1, true);
    MongoServer.listarPokemonsCapturados().then(
      (Loaded) => setState(() {
        pokemonsCapturados = Loaded;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemonsFavoreInfo = ref.watch(favoritesProvider);
    final FavoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFavorito = FavoritesNotifier.isFavorite(currentName);
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
                    top: 70,
                    left: 40,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarFavoritos = !mostrarFavoritos;
                        });
                      },
                      icon:
                          mostrarFavoritos
                              ? emCaptura
                                  ? SizedBox.shrink()
                                  : Icon(Icons.filter_list, size: 40)
                              : emCaptura
                              ? SizedBox.shrink()
                              : Icon(Icons.filter_list_off_sharp, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 140,
                    child: SizedBox(
                      width: 50,
                      child:
                          emCaptura
                              ? SizedBox.shrink()
                              : TextField(
                                controller: numberController,
                                onChanged:
                                    (value) => setState(() {
                                      Loading = true;
                                      if (int.parse(value) > 0) {
                                        pokemonUpdateHandler(
                                          int.parse(value),
                                          false,
                                        );
                                      }
                                    }),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 6,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: emCaptura ? 200 : 120,
                    child:
                        Loading
                            ? CircularProgressIndicator()
                            : Column(
                              children: [
                                emCaptura
                                    ? SizedBox.shrink()
                                    : Text(
                                      currentName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
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
                    child:
                        emCaptura
                            ? SizedBox.shrink()
                            : IconButton(
                              onPressed: () {
                                if (Loading) return;
                                if (mostrarFavoritos) {
                                  navegarFavorito(1, pokemonsFavoreInfo);
                                } else {
                                  if (mostarCapturados) {
                                    navegarCapturado(1);
                                  } else {
                                    setState(() {
                                      Loading = true;
                                      pokemonUpdateHandler(1, true);
                                    });
                                  }
                                }
                              },
                              icon: Icon(Icons.arrow_right_sharp, size: 100),
                            ),
                  ),
                  Positioned(
                    top: 110,
                    left: 10,
                    child:
                        emCaptura
                            ? SizedBox.shrink()
                            : IconButton(
                              onPressed: () {
                                if (Loading) return;
                                if (mostrarFavoritos) {
                                  navegarFavorito(-1, pokemonsFavoreInfo);
                                } else {
                                  if (mostarCapturados) {
                                    navegarCapturado(-1);
                                  } else {
                                    setState(() {
                                      Loading = true;
                                      pokemonUpdateHandler(-1, true);
                                    });
                                  }
                                }
                              },
                              icon:
                                  currentNumber != 1
                                      ? Icon(Icons.arrow_left_sharp, size: 100)
                                      : Text(''),
                            ),
                  ),
                  Positioned(
                    top: 70,
                    left: 240,
                    child:
                        (emCaptura ||
                                pokemonsCapturados.contains(
                                  currentNumber.toString(),
                                ))
                            ? SizedBox.shrink()
                            : IconButton(
                              onPressed: () {
                                isFavorito
                                    ? FavoritesNotifier.remove(currentName)
                                    : FavoritesNotifier.add({
                                      "name": currentName,
                                      "id": currentNumber,
                                    });
                              },
                              icon:
                                  isFavorito
                                      ? Icon(Icons.favorite, size: 40)
                                      : Icon(Icons.favorite_border, size: 40),
                            ),
                  ),
                  Positioned(
                    top: 80,
                    left: 60,
                    child:
                        emCaptura
                            ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final random = Random();
                                    final numeroSorteado =
                                        random.nextInt(10) + 1;
                                    if (numeroSorteado == 2 ||
                                        numeroSorteado == 5 ||
                                        numeroSorteado == 8) {
                                      await MongoServer.postPokemon({
                                        "id": currentNumber,
                                      });
                                      List<String> __pokemonsCapturados =
                                          await MongoServer.listarPokemonsCapturados();
                                      setState(() {
                                        textoSucessoCaptura =
                                            "Pokemon capturado!";
                                        sucessoCaptura = true;
                                        pokemonsCapturados =
                                            __pokemonsCapturados;
                                      });
                                    } else {
                                      setState(() {
                                        poke1Path =
                                            "assets/images/pokebola-aberta.png";
                                        if (poke1Path ==
                                                "assets/images/pokebola-aberta.png" &&
                                            poke2Path ==
                                                "assets/images/pokebola-aberta.png") {
                                          emCaptura = false;
                                        }
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    poke1Path,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () async {
                                    print("apertou a pokebola 3");
                                    final random = Random();
                                    final numeroSorteado =
                                        random.nextInt(10) + 1;
                                    if (numeroSorteado == 2 ||
                                        numeroSorteado == 5 ||
                                        numeroSorteado == 8) {
                                      await MongoServer.postPokemon({
                                        "id": currentNumber,
                                      });
                                      List<String> __pokemonsCapturados =
                                          await MongoServer.listarPokemonsCapturados();
                                      setState(() {
                                        textoSucessoCaptura =
                                            "Pokemon capturado!";
                                        sucessoCaptura = true;
                                        pokemonsCapturados =
                                            __pokemonsCapturados;
                                      });
                                    } else {
                                      setState(() {
                                        poke2Path =
                                            "assets/images/pokebola-aberta.png";
                                        if (poke1Path ==
                                                "assets/images/pokebola-aberta.png" &&
                                            poke2Path ==
                                                "assets/images/pokebola-aberta.png") {
                                          emCaptura = false;
                                        }
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    poke2Path,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            )
                            : SizedBox.shrink(),
                  ),
                  Positioned(
                    top: 230,
                    left: 50,
                    child: Text(
                      textoSucessoCaptura,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                    top: 230,
                    left: 250,
                    child:
                        mostrarFavoritos
                            ? GestureDetector(
                              onTap: () {
                                if (sucessoCaptura) {
                                  FavoritesNotifier.remove(currentName);
                                  sucessoCaptura = false;
                                }
                                textoSucessoCaptura = '';
                                poke1Path = "assets/images/pokebola-png.png";
                                poke2Path = "assets/images/pokebola-png.png";
                                if (pokemonsFavoreInfo.isNotEmpty) {
                                  final random = Random();
                                  final randomFavorito =
                                      pokemonsFavoreInfo[random.nextInt(
                                        pokemonsFavoreInfo.length,
                                      )];
                                  setState(() {
                                    if (!emCaptura) {
                                      currentName = randomFavorito['name'];
                                      currentNumber = randomFavorito['id'];
                                      numberController.text =
                                          currentNumber.toString();
                                      Loading = true;
                                    }
                                    emCaptura = !emCaptura;
                                  });
                                  pokemonUpdateHandler(currentNumber, false);
                                }
                              },
                              child:
                                  emCaptura
                                      ? Icon(
                                        Icons.run_circle_outlined,
                                        size: 40,
                                      )
                                      : Image.asset(
                                        "assets/images/pokebola-png.png",
                                        height: 40,
                                        width: 40,
                                      ),
                            )
                            : SizedBox.shrink(),
                  ),
                  Positioned(
                    top: 225,
                    left: 40,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          mostarCapturados = !mostarCapturados;
                        });
                      },
                      icon:
                          emCaptura
                              ? SizedBox.shrink()
                              : mostarCapturados
                              ? Icon(Icons.inventory, size: 35)
                              : Icon(Icons.inventory_2_outlined, size: 35),
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
