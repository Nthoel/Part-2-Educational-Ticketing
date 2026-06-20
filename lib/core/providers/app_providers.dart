import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/catalog_service.dart';
import '../../data/services/order_service.dart';
import '../../data/services/profile_service.dart';
import '../../data/services/token_storage_service.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/catalog/presentation/view_models/event_detail_view_model.dart';
import '../../features/catalog/presentation/view_models/event_list_view_model.dart';
import '../../features/orders/presentation/view_models/order_view_models.dart';
import '../../features/profile/presentation/view_models/profile_view_model.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final catalogServiceProvider = Provider<CatalogService>((ref) {
  return CatalogService();
});

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(authServiceProvider),
    tokenStorageService: ref.read(tokenStorageServiceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    profileService: ref.read(profileServiceProvider),
    tokenStorageService: ref.read(tokenStorageServiceProvider),
  );
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(catalogService: ref.read(catalogServiceProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(orderService: ref.read(orderServiceProvider));
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

final profileViewModelProvider = ChangeNotifierProvider<ProfileViewModel>((
  ref,
) {
  return ProfileViewModel(ref.read(profileRepositoryProvider));
});

final eventListViewModelProvider = ChangeNotifierProvider<EventListViewModel>((
  ref,
) {
  return EventListViewModel(ref.read(catalogRepositoryProvider));
});

final eventDetailViewModelProvider =
    ChangeNotifierProvider<EventDetailViewModel>((ref) {
      return EventDetailViewModel(ref.read(catalogRepositoryProvider));
    });

final createOrderViewModelProvider =
    ChangeNotifierProvider<CreateOrderViewModel>((ref) {
      return CreateOrderViewModel(ref.read(orderRepositoryProvider));
    });

final myOrdersViewModelProvider = ChangeNotifierProvider<MyOrdersViewModel>((
  ref,
) {
  return MyOrdersViewModel(ref.read(orderRepositoryProvider));
});

final orderDetailViewModelProvider =
    ChangeNotifierProvider<OrderDetailViewModel>((ref) {
      return OrderDetailViewModel(ref.read(orderRepositoryProvider));
    });
