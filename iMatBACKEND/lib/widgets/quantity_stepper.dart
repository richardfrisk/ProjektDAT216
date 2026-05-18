import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final double quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool fullWidth;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final display = quantity == quantity.roundToDouble()
        ? quantity.toInt().toString()
        : quantity.toStringAsFixed(1);

    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: fullWidth ? _buildFullWidth(display) : _buildCompact(display),
    );
  }

  Widget _buildCompact(String display) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _minusButton(compact: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            display,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        _plusButton(compact: true),
      ],
    );
  }

  Widget _buildFullWidth(String display) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _minusButton(compact: false)),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: Colors.black26),
                ),
              ),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(child: _plusButton(compact: false)),
        ],
      ),
    );
  }

  Widget _minusButton({required bool compact}) {
    return InkWell(
      onTap: onDecrease,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: compact ? 8 : 12,
          horizontal: compact ? 8 : 0,
        ),
        child: const Icon(Icons.remove, size: 18),
      ),
    );
  }

  Widget _plusButton({required bool compact}) {
    return InkWell(
      onTap: onIncrease,
      child: Container(
        color: const Color(0xFF1a1a2e),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: compact ? 8 : 12,
          horizontal: compact ? 8 : 0,
        ),
        child: const Icon(Icons.add, size: 18, color: Colors.white),
      ),
    );
  }
}
