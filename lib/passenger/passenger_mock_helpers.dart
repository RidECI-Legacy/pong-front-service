import '../data/car_colors.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import 'components/favorite_driver_card.dart';
import 'components/history_table.dart';
import 'components/nearby_trips_section.dart';
import 'components/status_badge.dart';

/// Small adapters that reshape the app's existing mock data into the shapes
/// the new passenger dashboard widgets expect, without touching the core
/// data layer (models.dart / mock_data.dart) used by the rest of the app.
class PassengerMockHelpers {
  PassengerMockHelpers._();

  static List<HistoryRowData> historyRows() {
    final drivers = MockData.availableTrips;
    final history = MockData.passengerHistory;
    const months = {
      'ene': 1, 'feb': 2, 'mar': 3, 'abr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'ago': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dic': 12,
    };

    DateTime parseDate(String label, int index) {
      final now = DateTime.now();
      if (label.toLowerCase().startsWith('hoy')) return now.subtract(Duration(hours: index));
      for (final entry in months.entries) {
        if (label.toLowerCase().contains(entry.key)) {
          return DateTime(now.year, entry.value, 25 - index);
        }
      }
      return now.subtract(Duration(days: index + 1));
    }

    final rows = <HistoryRowData>[];
    for (var i = 0; i < history.length; i++) {
      final item = history[i];
      final parts = item.route.split('→').map((s) => s.trim()).toList();
      final driver = drivers[i % drivers.length];
      rows.add(HistoryRowData(
        date: parseDate(item.date, i),
        dateLabel: item.date,
        origin: parts.isNotEmpty ? parts.first : item.route,
        destination: parts.length > 1 ? parts.last : '',
        driver: driver.driverName,
        vehicle: driver.car,
        price: item.amount,
        status: TripStatus.completed,
        rating: driver.rating,
      ));
    }
    return rows;
  }

  /// Favorite drivers shown on "Favoritos" and the dashboard preview.
  /// Reuses the real available-trip drivers and adds one synthetic entry so
  /// the list is rich enough to demonstrate search/sort without touching
  /// the core mock data layer.
  static List<FavoriteDriverEntry> favoriteDrivers() {
    final extra = MockData.availableTrips.first;
    final julian = TripOffer(
      driverName: 'Julián Torres',
      rating: 4.7,
      car: 'Mazda 2 Sedán',
      carColor: CarColor.green,
      origin: extra.origin,
      destination: extra.destination,
      time: '7:20 AM',
      seats: 2,
      price: 4200,
    );

    final entries = [
      ...MockData.availableTrips,
      julian,
    ].map((driver) {
      final tripsTogether = switch (driver.driverName) {
        'Andrés Peña' => 14,
        'Camilo Rojas' => 11,
        'Julián Torres' => 6,
        _ => 4,
      };
      final lastTripLabel = switch (driver.driverName) {
        'Camilo Rojas' => 'Hoy',
        'Andrés Peña' => 'Hace 2 días',
        'Julián Torres' => 'Hace 1 semana',
        _ => 'Hace 2 semanas',
      };
      final badge = driver.rating >= 4.9
          ? 'Conductor confiable'
          : (tripsTogether >= 10 ? 'Conductor frecuente' : null);
      final onlineNow = driver.driverName == 'Camilo Rojas' || driver.driverName == 'Andrés Peña';
      return FavoriteDriverEntry(driver: driver, tripsTogether: tripsTogether, lastTripLabel: lastTripLabel, badge: badge, onlineNow: onlineNow);
    }).toList();

    entries.sort((a, b) => b.driver.rating.compareTo(a.driver.rating));
    return entries;
  }

  static List<NearbyTrip> nearbyTrips() {
    final trips = MockData.availableTrips;
    return [
      for (var i = 0; i < trips.length; i++) NearbyTrip(offer: trips[i], distanceKm: 0.4 + i * 0.5, departsInMinutes: 6 + i * 4),
    ];
  }
}
