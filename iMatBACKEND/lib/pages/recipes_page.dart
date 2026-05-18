import 'package:flutter/material.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:provider/provider.dart';

class _Recipe {
  final String name;
  final String time;
  final int servings;
  final String difficulty;
  final String imageUrl;
  final List<String> ingredients;
  final String description;

  const _Recipe({
    required this.name,
    required this.time,
    required this.servings,
    required this.difficulty,
    required this.imageUrl,
    required this.ingredients,
    required this.description,
  });
}

const List<_Recipe> _recipes = [
  _Recipe(
    name: 'Pasta Bolognese',
    time: '40 min',
    servings: 4,
    difficulty: 'Lätt',
    imageUrl:
        'https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=600&fit=crop',
    ingredients: ['Köttfärs', 'Pasta', 'Krossade tomater', 'Olivolja'],
    description:
        'En klassisk italiensk köttfärssås med pasta – enkel, mättande och alltid uppskattad.',
  ),
  _Recipe(
    name: 'Lax med Grönsaker',
    time: '25 min',
    servings: 2,
    difficulty: 'Lätt',
    imageUrl:
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&fit=crop',
    ingredients: ['Laxfilé', 'Spenat', 'Morötter', 'Olivolja'],
    description:
        'Ugnsbakad lax med färska grönsaker – nyttig och smakrik middag på kort tid.',
  ),
  _Recipe(
    name: 'Jordgubbssmoothie',
    time: '5 min',
    servings: 2,
    difficulty: 'Mycket lätt',
    imageUrl:
        'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=600&fit=crop',
    ingredients: ['Jordgubbar', 'Banan', 'Yoghurt', 'Mjölk'],
    description:
        'Fruktig och krämig smoothie – perfekt till frukost eller som ett enkelt mellanmål.',
  ),
];

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
              ),
              border: Border.all(color: Color(0xFFFED7AA), width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            child: const Column(
              children: [
                Text('👨‍🍳', style: TextStyle(fontSize: 52)),
                SizedBox(height: 12),
                Text(
                  'Recept & Inspiration',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF92400E),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Hitta nya favoriter och handla ingredienserna direkt',
                  style: TextStyle(fontSize: 17, color: Color(0xFFB45309)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 800
                  ? 3
                  : constraints.maxWidth > 500
                  ? 2
                  : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.72,
                ),
                itemCount: _recipes.length,
                itemBuilder: (context, i) => _RecipeCard(recipe: _recipes[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final _Recipe recipe;

  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD4E8D8)),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 160,
            child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${recipe.time} · ${recipe.servings} port. · ${recipe.difficulty}',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.read<PageHandler>().navigateTo(ShopPage.shop),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Handla ingredienser'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE07B20),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
