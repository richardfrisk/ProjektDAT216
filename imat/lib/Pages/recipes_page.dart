import 'package:flutter/material.dart';
import 'package:imat/model/page_handler.dart';
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
    ingredients: ['Beef Mince', 'Penne Pasta', 'Chopped Tomatoes', 'Olive Oil'],
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
    ingredients: ['Salmon Fillets', 'Baby Spinach', 'Carrots', 'Olive Oil'],
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
    ingredients: ['Strawberries', 'Bananas', 'Greek Yoghurt', 'Full Fat Milk'],
    description:
        'Fruktig och krämig smoothie – perfekt till frukost eller som ett enkelt mellanmål.',
  ),
  _Recipe(
    name: 'Äggröra med Toast',
    time: '10 min',
    servings: 2,
    difficulty: 'Lätt',
    imageUrl:
        'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&fit=crop',
    ingredients: ['Free Range Eggs', 'Salted Butter', 'Wholemeal Bread'],
    description: 'Krämig äggröra på rostat bröd – en klassisk och snabb frukost.',
  ),
  _Recipe(
    name: 'Kycklingrissoppa',
    time: '50 min',
    servings: 4,
    difficulty: 'Medel',
    imageUrl:
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&fit=crop',
    ingredients: ['Chicken Breast', 'Basmati Rice', 'Carrots', 'Olive Oil'],
    description:
        'Värmande och mättande soppa – ett perfekt val för kalla dagar.',
  ),
  _Recipe(
    name: 'Fruktsallad',
    time: '10 min',
    servings: 4,
    difficulty: 'Mycket lätt',
    imageUrl:
        'https://images.unsplash.com/photo-1564093497595-593b96d80180?w=600&fit=crop',
    ingredients: ['Strawberries', 'Blueberries', 'Gala Apples', 'Bananas'],
    description:
        'Färgglad och fräsch fruktsallad – enkel att göra och alltid populär.',
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
          // Hero banner
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
              ),
              border: Border.all(color: const Color(0xFFFED7AA), width: 2),
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

          // Recipe grid
          LayoutBuilder(builder: (context, constraints) {
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
              itemBuilder: (context, i) =>
                  _RecipeCard(recipe: _recipes[i]),
            );
          }),
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
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant_menu_rounded,
                    size: 48, color: Colors.black26),
              ),
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),

                  // Meta row
                  Wrap(
                    spacing: 14,
                    children: [
                      _MetaTag(icon: Icons.timer_outlined, label: recipe.time),
                      _MetaTag(
                          icon: Icons.people_outline_rounded,
                          label: '${recipe.servings} port.'),
                      _MetaTag(
                          icon: Icons.bar_chart_rounded,
                          label: recipe.difficulty),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(recipe.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.5)),
                  const SizedBox(height: 12),

                  // Ingredient chips
                  const Text('INGREDIENSER',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: recipe.ingredients
                        .map((ing) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(ing,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF155F2A))),
                            ))
                        .toList(),
                  ),

                  const Spacer(),

                  // Shop button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.read<PageHandler>().navigateTo(ShopPage.shop),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Handla ingredienser'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE07B20),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
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

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black45),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}
