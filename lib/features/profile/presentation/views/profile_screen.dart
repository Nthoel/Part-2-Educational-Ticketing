import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import '../../../auth/presentation/views/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(profileViewModelProvider).loadProfile();
      final user = ref.read(profileViewModelProvider).user;
      if (user != null) {
        _nameController.text = user.name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _refreshProfile() async {
    await ref.read(profileViewModelProvider).loadProfile();
    final user = ref.read(profileViewModelProvider).user;
    if (user != null) {
      _nameController.text = user.name;
    }
  }

  Future<void> _saveName() async {
    if (_nameController.text.trim().isEmpty) return;

    final ok = await ref
        .read(profileViewModelProvider)
        .updateName(_nameController.text.trim());
    if (!mounted) return;

    final msg = ok
        ? 'Profil berhasil diperbarui'
        : (ref.read(profileViewModelProvider).errorMessage ??
              'Gagal update profil');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _logout() async {
    await ref.read(authViewModelProvider).logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            onPressed: profileVm.isLoading ? null : _refreshProfile,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NeoBrutalCard(
              backgroundColor: const Color(0xFFFFD93D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (profileVm.user != null) ...[
                    Text('ID: ${profileVm.user!.id}'),
                    Text('Email: ${profileVm.user!.email}'),
                  ] else if (profileVm.isLoading) ...[
                    const Text('Memuat profil...'),
                  ] else ...[
                    Text(
                      profileVm.errorMessage ?? 'Data profil belum tersedia',
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: profileVm.isLoading ? null : _saveName,
                          child: Text(
                            profileVm.isLoading
                                ? 'Menyimpan...'
                                : 'Simpan Nama',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: profileVm.isLoading ? null : _logout,
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
