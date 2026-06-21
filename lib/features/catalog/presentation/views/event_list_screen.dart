import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../../../tickets/presentation/views/my_tickets_screen.dart';
import 'event_detail_screen.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  final _searchController = TextEditingController();
  final _cityController = TextEditingController();
  final _scrollController = ScrollController();
  final _sortOptions = const [
    'event_at_asc',
    'event_at_desc',
    'price_asc',
    'price_desc',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(eventListViewModelProvider).initialize());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(eventListViewModelProvider).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyTicketsScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(eventListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Event')),
      body: SafeArea(
        child: Column(
          children: [
            _FilterSection(
              searchController: _searchController,
              cityController: _cityController,
              sortOptions: _sortOptions,
              selectedSort: vm.sort,
              onApply: () async {
                await vm.setSearch(_searchController.text);
                await vm.setCity(_cityController.text);
              },
              onReset: () async {
                _searchController.clear();
                _cityController.clear();
                await vm.setSearch('');
                await vm.setCity('');
                await vm.setCategory(null);
                await vm.setSort('event_at_asc');
              },
              onCategorySelected: (value) => vm.setCategory(value),
              categories: vm.categories,
              selectedCategoryId: vm.categoryId,
              onSortSelected: (value) => vm.setSort(value ?? vm.sort),
            ),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.errorMessage != null
                  ? Center(child: Text(vm.errorMessage!))
                  : RefreshIndicator(
                      onRefresh: vm.refresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            vm.events.length + (vm.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= vm.events.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final event = vm.events[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EventDetailScreen(eventId: event.id),
                                  ),
                                );
                              },
                              child: NeoBrutalCard(
                                backgroundColor: const Color(0xFFFFD93D),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          event.posterUrl != null &&
                                              event.posterUrl!.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: event.posterUrl!,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Image.asset(
                                                    'assets/images/placeholder.jpeg',
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  ),
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder.jpeg',
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${event.venue.name}, ${event.venue.city}',
                                          ),
                                          Text(
                                            DateFormat(
                                              'dd MMM yyyy, HH:mm',
                                            ).format(event.eventAt),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Kategori: ${event.categoryName}',
                                          ),
                                          Text(
                                            event.minPrice == null
                                                ? 'Harga: -'
                                                : 'Harga mulai: Rp ${event.minPrice!.toStringAsFixed(0)}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num_outlined),
            selectedIcon: Icon(Icons.confirmation_num),
            label: 'Tiket',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.searchController,
    required this.cityController,
    required this.sortOptions,
    required this.selectedSort,
    required this.onApply,
    required this.onReset,
    required this.onCategorySelected,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSortSelected,
  });

  final TextEditingController searchController;
  final TextEditingController cityController;
  final List<String> sortOptions;
  final String selectedSort;
  final Future<void> Function() onApply;
  final Future<void> Function() onReset;
  final Future<void> Function(int?) onCategorySelected;
  final List categories;
  final int? selectedCategoryId;
  final Future<void> Function(String?) onSortSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: NeoBrutalCard(
        backgroundColor: const Color(0xFF6BCBFF),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Cari event'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Kota'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int?>(
              initialValue: selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Semua Kategori'),
                ),
                ...categories.map(
                  (c) => DropdownMenuItem<int?>(
                    value: c.id as int,
                    child: Text(c.name as String),
                  ),
                ),
              ],
              onChanged: (value) {
                onCategorySelected(value);
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedSort,
              decoration: const InputDecoration(labelText: 'Urutkan'),
              items: sortOptions
                  .map(
                    (s) => DropdownMenuItem<String>(value: s, child: Text(s)),
                  )
                  .toList(),
              onChanged: (value) {
                onSortSelected(value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onApply();
                    },
                    child: const Text('Terapkan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onReset();
                    },
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
