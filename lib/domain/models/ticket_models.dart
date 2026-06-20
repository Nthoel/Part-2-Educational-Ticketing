class TicketEventSummary {
  const TicketEventSummary({
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
}

class TicketListItem {
  const TicketListItem({
    required this.id,
    required this.ticketCode,
    required this.status,
    required this.event,
  });

  final int id;
  final String ticketCode;
  final String status;
  final TicketEventSummary event;
}

class TicketHolder {
  const TicketHolder({required this.name, required this.email});

  final String name;
  final String email;
}

class TicketEventDetail {
  const TicketEventDetail({
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
}

class TicketTypeMini {
  const TicketTypeMini({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final double price;
}

class TicketDetail {
  const TicketDetail({
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
  final TicketHolder holder;
  final TicketEventDetail event;
  final TicketTypeMini ticketType;
}
