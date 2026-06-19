class VenueListRef {
  const VenueListRef({
    required this.id,
    required this.name,
    required this.city,
  });

  final int id;
  final String name;
  final String city;
}

class VenueDetail {
  const VenueDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  final int id;
  final String name;
  final String address;
  final String city;
}

class EventListItem {
  const EventListItem({
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
  final VenueListRef venue;
  final DateTime eventAt;
  final double? minPrice;
  final bool isAvailable;
}

class TicketTypeDetail {
  const TicketTypeDetail({
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
}

class EventDetail {
  const EventDetail({
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
  final VenueDetail venue;
  final DateTime eventAt;
  final DateTime salesStartAt;
  final DateTime salesEndAt;
  final String status;
  final List<TicketTypeDetail> ticketTypes;
}
