import '../../domain/models/event_models.dart';
import '../../domain/models/pagination_meta.dart';

class VenueListRefApiModel {
  const VenueListRefApiModel({
    required this.id,
    required this.name,
    required this.city,
  });

  final int id;
  final String name;
  final String city;

  factory VenueListRefApiModel.fromJson(Map<String, dynamic> json) {
    return VenueListRefApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }

  VenueListRef toDomain() {
    return VenueListRef(id: id, name: name, city: city);
  }
}

class VenueDetailApiModel {
  const VenueDetailApiModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  final int id;
  final String name;
  final String address;
  final String city;

  factory VenueDetailApiModel.fromJson(Map<String, dynamic> json) {
    return VenueDetailApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }

  VenueDetail toDomain() {
    return VenueDetail(id: id, name: name, address: address, city: city);
  }
}

class EventListItemApiModel {
  const EventListItemApiModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.categoryId,
    required this.categoryName,
    required this.venue,
    required this.eventAt,
    required this.minPrice,
    required this.isAvailable,
  });

  final int id;
  final String title;
  final String slug;
  final String? posterUrl;
  final int categoryId;
  final String categoryName;
  final VenueListRefApiModel venue;
  final DateTime eventAt;
  final double? minPrice;
  final bool isAvailable;

  factory EventListItemApiModel.fromJson(Map<String, dynamic> json) {
    final category =
        (json['category'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return EventListItemApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      posterUrl: json['poster_url'] as String?,
      categoryId: (category['id'] as num?)?.toInt() ?? 0,
      categoryName: category['name'] as String? ?? '',
      venue: VenueListRefApiModel.fromJson(
        (json['venue'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      eventAt:
          DateTime.tryParse(json['event_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      minPrice: (json['min_price'] as num?)?.toDouble(),
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  EventListItem toDomain() {
    return EventListItem(
      id: id,
      title: title,
      slug: slug,
      posterUrl: posterUrl,
      categoryId: categoryId,
      categoryName: categoryName,
      venue: venue.toDomain(),
      eventAt: eventAt,
      minPrice: minPrice,
      isAvailable: isAvailable,
    );
  }
}

class TicketTypeDetailApiModel {
  const TicketTypeDetailApiModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quota,
    required this.soldQuantity,
    required this.remainingQuantity,
  });

  final int id;
  final String name;
  final double price;
  final int quota;
  final int soldQuantity;
  final int remainingQuantity;

  factory TicketTypeDetailApiModel.fromJson(Map<String, dynamic> json) {
    return TicketTypeDetailApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quota: (json['quota'] as num?)?.toInt() ?? 0,
      soldQuantity: (json['sold_quantity'] as num?)?.toInt() ?? 0,
      remainingQuantity: (json['remaining_quantity'] as num?)?.toInt() ?? 0,
    );
  }

  TicketTypeDetail toDomain() {
    return TicketTypeDetail(
      id: id,
      name: name,
      price: price,
      quota: quota,
      soldQuantity: soldQuantity,
      remainingQuantity: remainingQuantity,
    );
  }
}

class EventDetailApiModel {
  const EventDetailApiModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.posterUrl,
    required this.categoryId,
    required this.categoryName,
    required this.venue,
    required this.eventAt,
    required this.salesStartAt,
    required this.salesEndAt,
    required this.status,
    required this.ticketTypes,
  });

  final int id;
  final String title;
  final String slug;
  final String description;
  final String? posterUrl;
  final int categoryId;
  final String categoryName;
  final VenueDetailApiModel venue;
  final DateTime eventAt;
  final DateTime salesStartAt;
  final DateTime salesEndAt;
  final String status;
  final List<TicketTypeDetailApiModel> ticketTypes;

  factory EventDetailApiModel.fromJson(Map<String, dynamic> json) {
    final category =
        (json['category'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final ticketTypesJson =
        (json['ticket_types'] as List<dynamic>?) ?? <dynamic>[];

    return EventDetailApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      posterUrl: json['poster_url'] as String?,
      categoryId: (category['id'] as num?)?.toInt() ?? 0,
      categoryName: category['name'] as String? ?? '',
      venue: VenueDetailApiModel.fromJson(
        (json['venue'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      eventAt:
          DateTime.tryParse(json['event_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      salesStartAt:
          DateTime.tryParse(json['sales_start_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      salesEndAt:
          DateTime.tryParse(json['sales_end_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: json['status'] as String? ?? '',
      ticketTypes: ticketTypesJson
          .map(
            (e) => TicketTypeDetailApiModel.fromJson(
              (e as Map<String, dynamic>?) ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }

  EventDetail toDomain() {
    return EventDetail(
      id: id,
      title: title,
      slug: slug,
      description: description,
      posterUrl: posterUrl,
      categoryId: categoryId,
      categoryName: categoryName,
      venue: venue.toDomain(),
      eventAt: eventAt,
      salesStartAt: salesStartAt,
      salesEndAt: salesEndAt,
      status: status,
      ticketTypes: ticketTypes.map((e) => e.toDomain()).toList(),
    );
  }
}

class PaginationMetaApiModel {
  const PaginationMetaApiModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  factory PaginationMetaApiModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaApiModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }

  PaginationMeta toDomain() {
    return PaginationMeta(
      page: page,
      perPage: perPage,
      total: total,
      totalPages: totalPages,
    );
  }
}
