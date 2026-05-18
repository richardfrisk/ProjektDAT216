import 'package:flutter/material.dart';
import 'package:imat_app/model/page_handler.dart';

void showOrderSuccessNotification(
  BuildContext context, {
  required int pointsEarned,
  required DeliveryOption delivery,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (overlayContext) => _OrderSuccessBanner(
      pointsEarned: pointsEarned,
      delivery: delivery,
      onDismiss: () {
        if (entry.mounted) entry.remove();
      },
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 5), () {
    if (entry.mounted) entry.remove();
  });
}

String _deliveryMessage(DeliveryOption delivery) {
  switch (delivery) {
    case DeliveryOption.asap:
      return 'Levereras snarast inom 2 timmar';
    case DeliveryOption.scheduled:
      return 'Leverans enligt vald tid';
  }
}

class _OrderSuccessBanner extends StatefulWidget {
  final int pointsEarned;
  final DeliveryOption delivery;
  final VoidCallback onDismiss;

  const _OrderSuccessBanner({
    required this.pointsEarned,
    required this.delivery,
    required this.onDismiss,
  });

  @override
  State<_OrderSuccessBanner> createState() => _OrderSuccessBannerState();
}

class _OrderSuccessBannerState extends State<_OrderSuccessBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 12;

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFF4),
                    border: Border.all(color: const Color(0xFF86EFAC), width: 2),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Beställning genomförd!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF166534),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.pointsEarned > 0
                                  ? 'Du fick ${widget.pointsEarned} poäng! ${_deliveryMessage(widget.delivery)}'
                                  : _deliveryMessage(widget.delivery),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF15803D),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _dismiss,
                        icon: const Icon(Icons.close, size: 20),
                        color: const Color(0xFF166534),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
