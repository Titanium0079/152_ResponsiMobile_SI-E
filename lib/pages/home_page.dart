import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../models/data.dart';
import '../services/recipe_api_service.dart';
import '../pages/favorite_recipes_page.dart';
import '../pages/login_page.dart';
import '../pages/recipe_detail_page.dart';
import 'recipe_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Recipe> _recipes = [];
  Set<int> _favoriteIds = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        RecipeApiService.fetchAllRecipes(),
        AppStorage.getFavoriteIds(),
      ]);
      if (!mounted) return;
      setState(() {
        _recipes = results[0] as List<Recipe>;
        _favoriteIds = (results[1] as List<int>).toSet();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int recipeId) async {
    final currentlyFav = _favoriteIds.contains(recipeId);
    final nextFav = !currentlyFav;

    setState(() {
      if (nextFav) {
        _favoriteIds.add(recipeId);
      } else {
        _favoriteIds.remove(recipeId);
      }
    });

    await AppStorage.setFavorite(recipeId, nextFav);
  }

  Future<void> _openDetailPage(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(
          recipe: recipe,
          isFavorite: _favoriteIds.contains(recipe.id),
          onToggleFavorite: () => _toggleFavorite(recipe.id),
        ),
      ),
    );
    final latestFavs = await AppStorage.getFavoriteIds();
    if (!mounted) return;
    setState(() {
      _favoriteIds = latestFavs.toSet();
    });
  }

  Future<void> _handleLogout() async {
    await AppStorage.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = _recipes
        .where((r) => _favoriteIds.contains(r.id))
        .toList();

    final pages = [
      RecipeListPage(
        recipes: _recipes,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        onRefresh: _loadInitialData,
        onSelectRecipe: _openDetailPage,
      ),
      FavoriteRecipesPage(
        favoriteRecipes: favoriteRecipes,
        isLoading: _isLoading,
        onSelectRecipe: _openDetailPage,
        onRemoveFavorite: (id) => _toggleFavorite(id),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Resep Masakan' : 'Favorite'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.green,
        indicatorColor: Colors.white,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: Colors.lightGreen),
            label: 'Resep',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite, color: Colors.lightGreen),
            label: 'Favorite (${favoriteRecipes.length})',
          ),
        ],
      ),
    );
  }
}
