import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/recipe_thumbnail.dart';

class FavoriteRecipesPage extends StatelessWidget {
  final List<Recipe> favoriteRecipes;
  final bool isLoading;
  final ValueChanged<Recipe> onSelectRecipe;
  final ValueChanged<int> onRemoveFavorite;

  const FavoriteRecipesPage({
    super.key,
    required this.favoriteRecipes,
    required this.isLoading,
    required this.onSelectRecipe,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favoriteRecipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_border,
                size: 56,
                color: Colors.indigo.shade200,
              ),
              const SizedBox(height: 12),
              const Text(
                'Belum ada resep favorit',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Buka halaman detail resep lalu tekan ikon hati untuk menambahkan ke favorit.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: favoriteRecipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final recipe = favoriteRecipes[index];
        return Card(
          color: Colors.white,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.indigo.shade50),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: RecipeThumbnail(imageUrl: recipe.image, size: 64),
            title: Text(
              recipe.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${recipe.cuisine} • ${recipe.difficulty} • ★ ${recipe.rating.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: IconButton(
              tooltip: 'Hapus dari Favorite',
              icon: const Icon(Icons.favorite, color: Colors.green),
              onPressed: () {
                onRemoveFavorite(recipe.id);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${recipe.name} dihapus dari favorite'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            onTap: () => onSelectRecipe(recipe),
          ),
        );
      },
    );
  }
}
