import '../data/mock_data.dart';
import '../data/models.dart';
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

  static List<TripOffer> favoriteDrivers() {
    final sorted = [...MockData.availableTrips]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(2).toList();
  }

  static List<NearbyTrip> nearbyTrips() {
    final trips = MockData.availableTrips;
    return [
      for (var i = 0; i < trips.length; i++) NearbyTrip(offer: trips[i], distanceKm: 0.4 + i * 0.5, departsInMinutes: 6 + i * 4),
    ];
  }
}
