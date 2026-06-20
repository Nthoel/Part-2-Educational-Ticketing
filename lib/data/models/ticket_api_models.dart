import '../../domain/models/ticket_models.dart';

class TicketEventSummaryApiModel {
  const TicketEventSummaryApiModel({
    required this.id,
    required this.title,
    required this.venueName,
    required this.city,
    required this.eventAt,
  });

  final int id;
  final String title;
  final String venueName;
  final String city;
  final DateTime eventAt;

  factory TicketEventSummaryApiModel.fromJson(Map<String, dynamic> json) {
    return TicketEventSummaryApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      venueName: json['venue_name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      eventAt:
          DateTime.tryParse(json['event_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  TicketEventSummary toDomain() {
    return TicketEventSummary(
      id: id,
      title: title,
      venueName: venueName,
      city: city,
      eventAt: eventAt,
    );
  }
}

class TicketListItemApiModel {
  const TicketListItemApiModel({
    required this.id,
    required this.ticketCode,
    required this.status,
    required this.event,
  });

  final int id;
  final String ticketCode;
  final String status;
  final TicketEventSummaryApiModel event;

  factory TicketListItemApiModel.fromJson(Map<String, dynamic> json) {
    return TicketListItemApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ticketCode: json['ticket_code'] as String? ?? '',
      status: json['status'] as String? ?? '',
      event: TicketEventSummaryApiModel.fromJson(
        (json['event'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  TicketListItem toDomain() {
    return TicketListItem(
      id: id,
      ticketCode: ticketCode,
      status: status,
      event: event.toDomain(),
    );
  }
}

class TicketHolderApiModel {
  const TicketHolderApiModel({required this.name, required this.email});

  final String name;
  final String email;

  factory TicketHolderApiModel.fromJson(Map<String, dynamic> json) {
    return TicketHolderApiModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  TicketHolder toDomain() {
    return TicketHolder(name: name, email: email);
  }
}

class TicketEventDetailApiModel {
  const TicketEventDetailApiModel({
    required this.id,
    required this.title,
    required this.venueName,
    required this.venueAddress,
    required this.city,
    required this.eventAt,
  });

  final int id;
  final String title;
  final String venueName;
  final String venueAddress;
  final String city;
  final DateTime eventAt;

  factory TicketEventDetailApiModel.fromJson(Map<String, dynamic> json) {
    return TicketEventDetailApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      venueName: json['venue_name'] as String? ?? '',
      venueAddress: json['venue_address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      eventAt:
          DateTime.tryParse(json['event_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  TicketEventDetail toDomain() {
    return TicketEventDetail(
      id: id,
      title: title,
      venueName: venueName,
      venueAddress: venueAddress,
      city: city,
      eventAt: eventAt,
    );
  }
}

class TicketTypeMiniApiModel {
  const TicketTypeMiniApiModel({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final double price;

  factory TicketTypeMiniApiModel.fromJson(Map<String, dynamic> json) {
    return TicketTypeMiniApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  TicketTypeMini toDomain() {
    return TicketTypeMini(id: id, name: name, price: price);
  }
}

class TicketDetailApiModel {
  const TicketDetailApiModel({
    required this.id,
    required this.ticketCode,
    required this.qrCodeValue,
    required this.status,
    required this.holder,
    required this.event,
    required this.ticketType,
  });

  final int id;
  final String ticketCode;
  final String qrCodeValue;
  final String status;
  final TicketHolderApiModel holder;
  final TicketEventDetailApiModel event;
  final TicketTypeMiniApiModel ticketType;

  factory TicketDetailApiModel.fromJson(Map<String, dynamic> json) {
    return TicketDetailApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ticketCode: json['ticket_code'] as String? ?? '',
      qrCodeValue: json['qr_code_value'] as String? ?? '',
      status: json['status'] as String? ?? '',
      holder: TicketHolderApiModel.fromJson(
        (json['holder'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      event: TicketEventDetailApiModel.fromJson(
        (json['event'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      ticketType: TicketTypeMiniApiModel.fromJson(
        (json['ticket_type'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  TicketDetail toDomain() {
    return TicketDetail(
      id: id,
      ticketCode: ticketCode,
      qrCodeValue: qrCodeValue,
      status: status,
      holder: holder.toDomain(),
      event: event.toDomain(),
      ticketType: ticketType.toDomain(),
    );
  }
}
