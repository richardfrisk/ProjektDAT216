import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/page_handler.dart';
import 'package:imat_app/widgets/order_success_notification.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 720,
              maxHeight: constraints.maxHeight - AppTheme.paddingLarge * 2,
            ),
            child: Card(
              margin: const EdgeInsets.all(AppTheme.paddingLarge),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Slutför köp',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          'Steg ${pageHandler.checkoutStepIndex + 1} av ${pageHandler.checkoutStepCount}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ProgressBar(current: pageHandler.checkoutStepIndex),
                    const SizedBox(height: 28),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildStep(context, pageHandler),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _NavigationButtons(pageHandler: pageHandler),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, PageHandler pageHandler) {
    switch (pageHandler.checkoutStep) {
      case CheckoutStep.address:
        return const _AddressStep();
      case CheckoutStep.delivery:
        return const _DeliveryStep();
      case CheckoutStep.payment:
        return const _PaymentStep();
      case CheckoutStep.confirm:
        return const _ConfirmStep();
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;

  const _ProgressBar({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
            decoration: BoxDecoration(
              color: i <= current ? AppTheme.primaryGreen : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _AddressStep extends StatelessWidget {
  const _AddressStep();

  @override
  Widget build(BuildContext context) {
    final customer = context.watch<ImatDataHandler>().getCustomer();
    final phone = customer.mobilePhoneNumber.isNotEmpty
        ? customer.mobilePhoneNumber
        : customer.phoneNumber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Leveransadress',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${customer.firstName} ${customer.lastName}'.trim(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(customer.address),
              Text('${customer.postCode} ${customer.postAddress}'),
              if (phone.isNotEmpty) Text(phone),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Vill du ändra din adress kan du göra det under "Profil"',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _DeliveryStep extends StatelessWidget {
  const _DeliveryStep();

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Välj leveranstid',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _OptionCard(
          selected: pageHandler.deliveryOption == DeliveryOption.asap,
          icon: Icons.schedule_rounded,
          title: 'Snarast',
          subtitle: 'Leverans inom 2 timmar',
          onTap: () => pageHandler.setDeliveryOption(DeliveryOption.asap),
        ),
        const SizedBox(height: 12),
        _OptionCard(
          selected: pageHandler.deliveryOption == DeliveryOption.scheduled,
          icon: Icons.event_rounded,
          title: 'Välj tid',
          subtitle: 'Bestäm när du vill ha leverans',
          onTap: () => pageHandler.setDeliveryOption(DeliveryOption.scheduled),
        ),
      ],
    );
  }
}

class _PaymentStep extends StatelessWidget {
  const _PaymentStep();

  @override
  Widget build(BuildContext context) {
    final pageHandler = context.watch<PageHandler>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.credit_card_rounded, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Betalningssätt',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _PaymentOption(
          label: 'Betala med kort (vid leverans)',
          selected: pageHandler.paymentMethod == PaymentMethod.cardOnDelivery,
          onTap: () => pageHandler.setPaymentMethod(PaymentMethod.cardOnDelivery),
        ),
        _PaymentOption(
          label: 'Faktura',
          selected: pageHandler.paymentMethod == PaymentMethod.invoice,
          onTap: () => pageHandler.setPaymentMethod(PaymentMethod.invoice),
        ),
        _PaymentOption(
          label: 'Swish',
          selected: pageHandler.paymentMethod == PaymentMethod.swish,
          onTap: () => pageHandler.setPaymentMethod(PaymentMethod.swish),
        ),
      ],
    );
  }
}

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep();

  String _paymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cardOnDelivery:
        return 'Betala med kort';
      case PaymentMethod.invoice:
        return 'Faktura';
      case PaymentMethod.swish:
        return 'Swish';
    }
  }

  String _deliveryLabel(DeliveryOption option) {
    switch (option) {
      case DeliveryOption.asap:
        return 'Snarast (inom 2 timmar)';
      case DeliveryOption.scheduled:
        return 'Vald tid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final pageHandler = context.watch<PageHandler>();
    final customer = data.getCustomer();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Bekräfta din beställning',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(
                label: 'Leveransadress',
                value: '${customer.address}, ${customer.postCode} ${customer.postAddress}',
              ),
              _SummaryRow(
                label: 'Leveranstid',
                value: _deliveryLabel(pageHandler.deliveryOption),
              ),
              _SummaryRow(
                label: 'Betalningssätt',
                value: _paymentLabel(pageHandler.paymentMethod),
              ),
              _SummaryRow(
                label: 'Totalt',
                value: '${data.shoppingCartTotal().toStringAsFixed(0)} kr',
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 20 : 16,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              color: bold ? AppTheme.primaryGreen : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FFF4) : Colors.white,
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected ? Colors.black : Colors.black38,
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final PageHandler pageHandler;

  const _NavigationButtons({required this.pageHandler});

  @override
  Widget build(BuildContext context) {
    final isFirst = pageHandler.checkoutStep == CheckoutStep.address;
    final isLast = pageHandler.checkoutStep == CheckoutStep.confirm;

    return Row(
      children: [
        if (!isFirst)
          Expanded(
            child: OutlinedButton(
              onPressed: pageHandler.previousCheckoutStep,
              child: const Text('Tillbaka'),
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () async {
              if (isLast) {
                final data = context.read<ImatDataHandler>();
                final total = data.shoppingCartTotal();
                final pointsEarned = (total / 10).floor();
                final delivery = pageHandler.deliveryOption;

                data.addExtra(
                  'lastPaymentMethod',
                  pageHandler.paymentMethod.name,
                );
                data.addExtra(
                  'lastDeliveryOption',
                  delivery.name,
                );
                await data.placeOrder();

                if (!context.mounted) return;

                pageHandler.clearCategory();
                pageHandler.navigateTo(ShopPage.shop);
                showOrderSuccessNotification(
                  context,
                  pointsEarned: pointsEarned,
                  delivery: delivery,
                );
              } else {
                pageHandler.nextCheckoutStep();
              }
            },
            child: Text(isLast ? 'Slutför köp' : 'Nästa'),
          ),
        ),
        TextButton(
          onPressed: pageHandler.cancelCheckout,
          child: const Text('Avbryt'),
        ),
      ],
    );
  }
}
