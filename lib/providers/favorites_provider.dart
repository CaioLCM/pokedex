  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
    FavoritesNotifier() : super([]);

    void add(Map<String, dynamic> pokemon){
      if (!state.any((poke) => poke['name'] == pokemon['name'])){
        state = [...state, pokemon];
      }
    }

    void remove(String name){
      state = state.where((poke) => poke['name'] != name).toList();
    }

    bool isFavorite(String name){
      return state.any((poke) => poke['name'] == name);
    }
  }

  final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>((ref) => FavoritesNotifier());