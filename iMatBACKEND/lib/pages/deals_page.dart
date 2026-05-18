import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

/// Category id used in [PageHandler.navigateToCategory].
const String dealsCategoryId = 'deals';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final pageHandler = context.read<PageHandler>();
    final deals = data.getAllDeals();
    final dealCount = deals.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFFFFFBEB),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: pageHandler.clearCategory,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Tillbaka till butiken'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF92400E),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.percent_rounded,
                          color: Color(0xFF92400E),
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Alla erbjudanden',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$dealCount erbjudanden',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: deals.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 900
                          ? 4
                          : constraints.maxWidth > 600
                          ? 3
                          : 2;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: deals.length,
                        itemBuilder: (context, i) => DealCard(
                          product: deals[i].product,
                          originalPrice: deals[i].originalPrice,
                          validUntil: deals[i].validUntil,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
