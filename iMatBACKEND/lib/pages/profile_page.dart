import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late final TextEditingController _mobile;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _postCode;
  late final TextEditingController _postAddress;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phone = TextEditingController();
    _mobile = TextEditingController();
    _email = TextEditingController();
    _address = TextEditingController();
    _postCode = TextEditingController();
    _postAddress = TextEditingController();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _mobile.dispose();
    _email.dispose();
    _address.dispose();
    _postCode.dispose();
    _postAddress.dispose();
    super.dispose();
  }

  void _loadFromCustomer(Customer customer) {
    _firstName.text = customer.firstName;
    _lastName.text = customer.lastName;
    _phone.text = customer.phoneNumber;
    _mobile.text = customer.mobilePhoneNumber;
    _email.text = customer.email;
    _address.text = customer.address;
    _postCode.text = customer.postCode;
    _postAddress.text = customer.postAddress;
  }

  void _startEditing(Customer customer) {
    _loadFromCustomer(customer);
    setState(() => _editing = true);
  }

  void _cancelEditing(Customer customer) {
    _loadFromCustomer(customer);
    setState(() => _editing = false);
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final data = context.read<ImatDataHandler>();
    final updated = Customer(
      _firstName.text.trim(),
      _lastName.text.trim(),
      _phone.text.trim(),
      _mobile.text.trim(),
      _email.text.trim(),
      _address.text.trim(),
      _postCode.text.trim(),
      _postAddress.text.trim(),
    );

    final saved = await data.setCustomer(updated);
    if (!context.mounted) return;

    if (saved) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profilen har sparats')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kunde inte spara profilen. Försök igen.'),
          backgroundColor: Color(0xFFB91C1C),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ImatDataHandler>();
    final customer = data.getCustomer();
    final points = data.loyaltyPoints;
    final phone = customer.mobilePhoneNumber.isNotEmpty
        ? customer.mobilePhoneNumber
        : customer.phoneNumber;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        size: 48,
                        color: Color(0xFFD97706),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dina poäng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$points',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          '1 poäng = 10 kr handlat\n100 poäng = 50 kr rabatt',
                          style: TextStyle(color: Colors.black54, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Min profil',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_editing) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _EditField(
                                  controller: _firstName,
                                  label: 'Förnamn',
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Ange förnamn'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _EditField(
                                  controller: _lastName,
                                  label: 'Efternamn',
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Ange efternamn'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          _EditField(
                            controller: _address,
                            label: 'Gatuadress',
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _EditField(
                                  controller: _postCode,
                                  label: 'Postnummer',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: _EditField(
                                  controller: _postAddress,
                                  label: 'Ort',
                                ),
                              ),
                            ],
                          ),
                          _EditField(
                            controller: _mobile,
                            label: 'Mobiltelefon',
                          ),
                          _EditField(
                            controller: _phone,
                            label: 'Telefon',
                          ),
                          _EditField(
                            controller: _email,
                            label: 'E-post',
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _ProfileField(
                                  label: 'Namn',
                                  value:
                                      '${customer.firstName} ${customer.lastName}'
                                          .trim(),
                                ),
                                _ProfileField(
                                  label: 'Adress',
                                  value:
                                      '${customer.address}, ${customer.postCode} ${customer.postAddress}',
                                ),
                                _ProfileField(label: 'Telefon', value: phone),
                                _ProfileField(
                                  label: 'E-post',
                                  value: customer.email,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (_editing)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _cancelEditing(customer),
                                  child: const Text('Avbryt'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () => _save(context),
                                  child: const Text('Spara profil'),
                                ),
                              ),
                            ],
                          )
                        else
                          ElevatedButton(
                            onPressed: () => _startEditing(customer),
                            child: const Text('Redigera profil'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _EditField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
