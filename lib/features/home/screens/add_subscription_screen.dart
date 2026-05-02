import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../subscriptions/models/subscription.dart';
import '../../subscriptions/providers/subscription_provider.dart';
import '../../subscriptions/data/subscription_presets.dart';

class AddSubscriptionScreen extends ConsumerStatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  ConsumerState<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends ConsumerState<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _websiteController = TextEditingController();
  
  String _selectedCategory = 'AI/LLM';
  String _billingCycle = 'monthly';
  bool _isTrial = false;
  DateTime _startDate = DateTime.now();
  DateTime? _trialEndDate;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Search or select a service',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Search services...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            _buildPresetList(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Or add manually',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Subscription Name',
                hintText: 'e.g., Netflix, Spotify',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '9.99',
                prefixText: '\$ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _billingCycle,
              decoration: const InputDecoration(labelText: 'Billing Cycle'),
              items: const [
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                DropdownMenuItem(value: 'semi-annual', child: Text('Semi-Annual')),
                DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
              ],
              onChanged: (value) {
                setState(() => _billingCycle = value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: SubscriptionPresets.categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website (optional)',
                hintText: 'https://example.com',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Free Trial'),
              subtitle: const Text('This is a trial subscription'),
              value: _isTrial,
              onChanged: (value) {
                setState(() => _isTrial = value);
              },
            ),
            if (_isTrial) ...[
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Trial End Date'),
                subtitle: Text(_trialEndDate?.toString().split(' ')[0] ?? 'Select date'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _trialEndDate = date);
                  }
                },
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSubscription,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Save Subscription'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetList() {
    final query = _nameController.text;
    if (query.isEmpty) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: SubscriptionPresets.categories.length,
          itemBuilder: (context, index) {
            final cat = SubscriptionPresets.categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ActionChip(
                avatar: Text(SubscriptionPresets.categoryIcons[cat] ?? ''),
                label: Text(cat),
                onPressed: () {
                  setState(() => _selectedCategory = cat);
                  _showCategoryPresets(cat);
                },
              ),
            );
          },
        ),
      );
    }

    final results = SubscriptionPresets.search(query);
    if (results.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No results found')),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: results.length,
        itemBuilder: (context, index) {
          final preset = results[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => _selectPreset(preset),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      preset['icon'] ?? '📦',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      preset['name'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '\$${preset['amount']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCategoryPresets(String category) {
    final presets = SubscriptionPresets.byCategory(category);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: presets.length,
                  itemBuilder: (context, index) {
                    final preset = presets[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _selectPreset(preset);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              preset['icon'] ?? '📦',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              preset['name'],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectPreset(Map<String, dynamic> preset) {
    _nameController.text = preset['name'];
    _amountController.text = preset['amount'].toString();
    _selectedCategory = preset['category'];
    _billingCycle = preset['billingCycle'];
    _websiteController.text = preset['website'] ?? '';
    setState(() {});
  }

  void _saveSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    final uuid = const Uuid();
    final subscription = Subscription(
      id: uuid.v4(),
      name: _nameController.text,
      amount: double.parse(_amountController.text),
      billingCycle: _billingCycle,
      startDate: _startDate,
      category: _selectedCategory,
      isTrial: _isTrial,
      trialEndDate: _trialEndDate,
      website: _websiteController.text.isNotEmpty ? _websiteController.text : null,
    );

    await ref.read(subscriptionProvider.notifier).addSubscription(subscription);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription added!')),
      );
      Navigator.pop(context);
    }
  }
}